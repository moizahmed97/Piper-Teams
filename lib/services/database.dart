import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection references
  final CollectionReference teamMemberCollection =
      Firestore.instance.collection('TeamMember');

  final CollectionReference supervisorCollection =
      Firestore.instance.collection('Supervisor');

  final CollectionReference userCollection =
      Firestore.instance.collection('User');

  // Adding a User to the Database
  Future<void> addUserToDatabase(String email) async {
    // Create a new user if it isnt there with the given uid
    return await userCollection.document(uid).setData({
      'userID': this.uid,
      'email': email,
      'registerDate': DateTime.now(),
      'teamMember': "",
      'supervisor': "",
    });
  }

  // Returns all the Tasks in the tasks collection as task Objects
  List<Task> _tasksFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
        dateCreated: doc.data['dateCreated'].toDate() ?? '',
        deadline: doc.data['deadline'].toDate() ?? '',
        taskType: doc.data['taskType'] ?? 0,
        feedback: doc.data['feedback'] ?? '',
        status: doc.data['status'] ?? false,
        grade: doc.data['grade'] ?? '',
        task: doc.data['task'] ?? '',
      );
    }).toList();
  }

  // Get Tasks Stream for the given team member from the tasks collection
  Stream<List<Task>> getTeamMemberTasks(teamMemberID) {
    try {
      final CollectionReference teamMemberTasksCollection =
          Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
      return teamMemberTasksCollection
          .orderBy('deadline', descending: false)
          .snapshots()
          .map(_tasksFromSnapshot);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Returns Student attendance objects
  List<SimpleTeamMemberInfo> _simpleTeamMemberInfoFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SimpleTeamMemberInfo(
          name: doc.data['name'], teamMemberID: doc.data['teamMemberID']);
    }).toList();
  }

  // Returns all the teamMember documents in a team
  Stream<List<SimpleTeamMemberInfo>> getTeamMembersInTeam(supervisorID, team) {
    final CollectionReference teamCollection =
        Firestore.instance.collection('Supervisor/$supervisorID/$team');
    return teamCollection.snapshots().map(_simpleTeamMemberInfoFromSnapshot);
  }

  List<Task> _latestTaskFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
        dateCreated: doc.data['dateCreated'].toDate(),
        deadline: doc.data['deadline'].toDate(),
        taskType: doc.data['taskType'],
        feedback: doc.data['feedback'],
        status: doc.data['status'],
        grade: doc.data['grade'],
        task: doc.data['task'],
      );
    }).toList();
  }

  // Get the LatestTask document for the given teamMember in the Latest Collection
  Stream<List<Task>> getLatestTask(String teamMemberID) {
    CollectionReference latestCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Latest');
    return latestCollection.snapshots().map(_latestTaskFromSnapshot);
  }

  // Update the grade of a task for a team member with the specified task type
  Future<void> updateGradeForLatestTask(
      String teamMemberID, int taskType, String grade) async {
    return await teamMemberCollection
        .document(teamMemberID)
        .collection('Latest')
        .document('$taskType')
        .updateData({'grade': grade});
  }

  // Update the document LatestTask for a given team member
  Future<void> updateLatestTask(String teamMemberID, Task latestTask) async {
    CollectionReference latestCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Latest');

    return await latestCollection.document('${latestTask.taskType}').setData({
      'dateCreated': latestTask.dateCreated,
      'deadline': latestTask.deadline,
      'taskType': latestTask.taskType,
      'feedback': latestTask.feedback,
      'status': latestTask.status,
      'grade': latestTask.grade,
      'task': latestTask.task,
    });
  }

  Future<void> createNewTask(String teamMemberID, Task latestTask) async {
    CollectionReference latestCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Latest');
    DocumentReference ref = latestCollection.document();

    return await ref.setData({
      'dateCreated': latestTask.dateCreated,
      'deadline': latestTask.deadline,
      'taskType': latestTask.taskType,
      'feedback': latestTask.feedback,
      'status': latestTask.status,
      'grade': ref
          .documentID, // Stores the documents ID which is to be used for updating status
      'task': latestTask.task,
    });
  }

  Future<void> updateTaskStatus(
      String teamMemberID, String taskID, bool newStatus) async {
    CollectionReference latestCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Latest');
    DocumentReference ref = latestCollection.document('$taskID');

    return await ref.updateData({'status': newStatus});
  }

  SimpleUser _getUserDocFromSnapshot(DocumentSnapshot snapshot) {
    return SimpleUser(
        email: snapshot.data['email'],
        supervisor: snapshot.data['supervisor'],
        teamMember: snapshot.data['teamMember'],
        uid: snapshot.data['userID'],
        registerDate: snapshot.data['registerDate'].toDate());
  }

  // Get the Simple User Document for the given userID
  Stream<SimpleUser> getUserDocument(String userID) {
    var document = userCollection.document(userID);
    return document.snapshots().map((_getUserDocFromSnapshot));
  }

  Future<void> createSupervisor(uid, name, age) async {
    await supervisorCollection
        .document(uid)
        .setData({'name': '$name', 'age': '$age'});

    // create the team collection with dummy data
    await supervisorCollection
        .document(uid)
        .collection('Team')
        .document()
        .setData({
      'Name': "Test Member",
      'teamMemberID': "Placeholder teamMemberID",
    });
  }

  // Adds the name of the newly created Supervisor to the User Document
  Future<void> addSupervisorNameToUser(String uid, String name) async {
    return await userCollection.document(uid).updateData({'supervisor': name});
  }
}
