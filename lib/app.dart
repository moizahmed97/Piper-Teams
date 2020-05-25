import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/authenticatedUser.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/screens/Supervisor/supervisorController.dart';
import 'package:piper_team_tasks/screens/Supervisor/supervisorProfileTab.dart';
import 'package:piper_team_tasks/screens/Student/teamMemberController.dart';
import 'package:piper_team_tasks/screens/Student/studentProfileTab.dart';
import 'package:piper_team_tasks/screens/User/userSwitchingPage.dart';
import 'package:piper_team_tasks/screens/authenicate/authenticate.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/theme.dart';

class PiperTeamTasks extends StatefulWidget {
  @override
  _PiperTeamTasksState createState() => _PiperTeamTasksState();
}

class _PiperTeamTasksState extends State<PiperTeamTasks> {
  @override
  Widget build(BuildContext context) {

    // Get the user stream from the main.dart 
    final user = Provider.of<AuthenticatedUser>(context);

    print(user);


    // If no user is authenticated then display the Authentication pages
    if (user == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Piper Team Tasks",
        theme: BuildTheme.lightTheme,
        home: Authenticate(),
        routes: {
          '/supervisorHome': (context) => SupervisorController(),
          '/teamMemberHome': (context) => TeamMemberController()
        },
      );
    }
    // If there is a user Signed in show the User switching page 
    else {
      return StreamProvider<SimpleUser>.value(
        value: DatabaseService().getUserDocument(user.uid),
        child: MaterialApp(
          darkTheme: BuildTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          title: "Piper Team Tasks",
          theme: BuildTheme.lightTheme,
          home: UserSwitchingPage(),
          routes: {
            '/supervisorHome': (context) => SupervisorController(),
            '/instructorProfile': (context) => ProfileTab(),
            '/userSwitchPage': (context) => UserSwitchingPage(),
            '/studentProfile': (context) => ProfileTabS(),
            '/teamMemberHome': (context) => TeamMemberController(),
          },
        ),
      );
    }
  }
}
