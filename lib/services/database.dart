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
        taskID: doc.data['taskID'] ?? '',
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

  // Returns simple team member objects
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

  List<Task> _allTasksFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
        dateCreated: doc.data['dateCreated'].toDate(),
        deadline: doc.data['deadline'].toDate(),
        taskType: doc.data['taskType'],
        feedback: doc.data['feedback'],
        status: doc.data['status'],
        taskID: doc.data['taskID'],
        task: doc.data['task'],
      );
    }).toList();
  }

  // Get the LatestTask document for the given teamMember in the Tasks Collection
  Stream<List<Task>> getAllTasks(String teamMemberID) {
    CollectionReference latestCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
    return latestCollection.snapshots().map(_allTasksFromSnapshot);
  }

  Task _taskFromSnapshot(DocumentSnapshot snapshot) {
    return Task(
      dateCreated: snapshot.data['dateCreated'].toDate(),
      deadline: snapshot.data['deadline'].toDate(),
      taskType: snapshot.data['taskType'],
      feedback: snapshot.data['feedback'],
      status: snapshot.data['status'],
      taskID: snapshot.data['taskID'],
      task: snapshot.data['task'],
    );
  }

  Stream<Task> getTask(String teamMemberID, String taskID) {
    CollectionReference tasksCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
    return tasksCollection.document(taskID).snapshots().map(_taskFromSnapshot);
  }

  Future<void> createNewTask(String teamMemberID, Task newTask) async {
    CollectionReference tasksCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
    DocumentReference ref = tasksCollection.document();

    return await ref.setData({
      'dateCreated': newTask.dateCreated,
      'deadline': newTask.deadline,
      'taskType': newTask.taskType,
      'feedback': newTask.feedback,
      'status': newTask.status,
      'taskID': ref
          .documentID, // Stores the documents ID which is to be used for updating status
      'task': newTask.task,
    });
  }

  Future<void> updateExisitngTask(String teamMemberID, Task updatedTask) async {
    CollectionReference tasksCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
    DocumentReference ref = tasksCollection.document(updatedTask.taskID);

    return await ref.setData({
      'dateCreated': updatedTask.dateCreated,
      'deadline': updatedTask.deadline,
      'taskType': updatedTask.taskType,
      'feedback': updatedTask.feedback,
      'status': updatedTask.status,
      'taskID': updatedTask.taskID,
      'task': updatedTask.task,
    });
  }

  Future<void> updateTaskStatus(
      String teamMemberID, String taskID, bool newStatus) async {
    CollectionReference tasksCollection =
        Firestore.instance.collection('TeamMember/$teamMemberID/Tasks');
    DocumentReference ref = tasksCollection.document('$taskID');

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
    return await supervisorCollection
        .document(uid)
        .setData({'name': '$name', 'age': '$age'});
  }

  // Adds the name of the newly created Supervisor to the User Document
  Future<void> addSupervisorNameToUser(String uid, String name) async {
    return await userCollection.document(uid).updateData({'supervisor': name});
  }
}
