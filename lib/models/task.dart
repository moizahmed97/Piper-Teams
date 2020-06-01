class Task {
  DateTime dateCreated;
  DateTime deadline;
  int taskType; // 0 for Critical, 1 for Normal or 2 for Low
  String feedback;
  bool status; //completed the task or incomplete
  String grade;   // Use this to store the ID of the doc 
  String task;

  Task({
    this.dateCreated,
    this.deadline,
    this.taskType,
    this.feedback,
    this.status,
    this.grade,
    this.task,
  });

  @override
  String toString() {
    return '{ ${this.dateCreated}, ${this.deadline}, ${this.taskType}, '
        '${this.task} }';
  }
}
