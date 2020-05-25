class Plan {
  DateTime dateCreated;
  DateTime dateStarting;

  DateTime dateEnding;
  bool status; // active or inactive
  int planType;
  double progress; // Progress in percentage like 0.8
  String from;
  String to;

  Plan({this.dateCreated, this.dateEnding, this.dateStarting, this.planType, this.progress, this.status, this.from, this.to});

}
