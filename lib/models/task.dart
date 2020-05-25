class Task {
  DateTime dateCreated;
  DateTime deadline;
  int taskType; // 0 for Critical, 1 for Normal or 2 for Low
  String feedback;
  bool status; //completed the assignment or incomplete
  String grade;
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
