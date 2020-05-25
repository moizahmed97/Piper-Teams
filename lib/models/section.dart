import 'package:piper_team_tasks/models/teamMember.dart';

class Section {
  final DateTime time;
  final List<TeamMember> acceptedMembers;
  final List<TeamMember> pendingMembers;

  Section(this.acceptedMembers, this.pendingMembers, this.time);
}
