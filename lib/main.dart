import 'package:flutter/material.dart';
import 'package:piper_team_tasks/app.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/authenticatedUser.dart';
import 'package:piper_team_tasks/services/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthenticatedUser>.value(
        value: AuthService().user,
        child: PiperTeamTasks());
  }
}
