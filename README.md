# Piper Teams
Cross Platform Mobile App for Android and iOS that helps teams work together effectively

### Download

Download and test the Android app on your device [Link](https://drive.google.com/file/d/1lIc5MPWRpBo_sF0FWeimwf1ItUUEMtTi/view?usp=sharing).

### Demo Video 
To View the Demo and learn how to use the App [(Watch Video)](https://www.youtube.com/watch?v=3DRATu-SnRI).
Visit our app channel for further details

### Application Architecture 
```
                      |------- Firebase Authentication (For Sign In and Sign Up of users)
                      
Flutter -> Firebase---|------- Cloud Firestore (NoSQL cloud database for storing Data)

                      |------- Firebase Cloud Functions   
```

### Features 

#### Authentication 
The App uses Firebase authentication to authenticate users and allow different roles. 

#### Data Storage 
To Store user and team Data the app uses Cloud Firestore, a NoSQL Database that is flexible, syncs in real time with offline support

#### Accessibility
The app is built with a Cloud first approach, therefore users can access teams and team data from anywhere, any device at anytime. Simply download the app and Login.

#### Types of Users
1. Team Manager
   - Can Create Teams
   - Invite Team Members to Join the Team
   - Assign Tasks by priority and Plans to individual Team members
   - Grade or Delete Tasks for team members
2. Team Member
   - Join a team with the unique code
   - Leave a team
   - Mark tasks assigned as complete 
   - Update progress on plans assigned by the manager

### Developers 
Developed by 
- Moiz Ahmed [(GitHub)](https://github.com/moizahmed97)
- Faisal Abdus Sattar [(GitHub)](https://github.com/fsmonarchy)

### Screenshots

![alt text](https://drive.google.com/file/d/1Vr6hbvwucrcxi3euNC-5FNDsL_y6D-_A/view)


