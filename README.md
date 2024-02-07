
<p align="center"> <img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExaWpuNGszb3g2Zjlsd3R1eHdlaXRwODdnenVkY3dpbWs3c2drOTRtaSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/NFU2xOlW7hHs9aLjsC/giphy.gif" /> </p>

<h1 align="center"> PickUP </h1>

<div align="center"> Say farewell to haphazardly organized games, the endless wait for that one last player to complete a full team, and all of your pickup sports game woes with PickUP. This app will redefine the way you organize and participate in a variety of sports (basketball, volleyball, soccer, pickleball, etc). Made specifically for college students, PickUP provides access to a dynamic, user-friendly platform that will keep you informed about various sports games happening around your campus in real-time. This powerful app bridges the gap between sports enthusiasts and available games, turning spontaneous matches into well-attended, memorable events.</div>


## MVP 💰

 -  User Account
	 -   User authentication with username and password
	 -   Email domain verification for UTD students
	 -   Personalization - ex: profile photo, skill level, etc.
 - Live Map
	 -   Display map of live games  
	 -   Show user's live location   
 -   Game Creation
	 -   Ability to create a game for chosen sport
	 -   Add location, players needed, and other details
	 -   Notification sent when game is live
	 -   Display game on map
 - Push Notifications
	 -   When game starts or when players are needed
- Player/Game Customization
	-    Role specification for game (ex: goalie, center, etc)
	- Game level - beginner-friendly or experienced players

## Stretch Goals 🙆
-   Allow users to rate each other based on sportsmanship and how good they are at the sport
-   Chat integration - can be used if more information is needed
-   Allow users to add friends from their college in the app
-   Create leagues
-   Integrate the app with Universities IM leagues
-   Extend map and user base outside of UTD campus


## Milestones 🏃‍♂️
|Week| Deliverables/Tasks |
|--|--|
| 1 | Meet team, set up development environment, explore idea using similar apps |
| 2 & 3 | *Front end:* plan pages, create wireframes & code initial screens, *Back end:* set up database for storage and setup user authentication
| 4 |*Front end:* 50% of app screens, *Back-end:* work on implementing game creation, integrate with frontend|
| 5 & 6 | *Front end:* complete 75% of screens, *Back end:* work on live map and location, push notifications, and continue to integrate with frontend as needed | 
| 7 | *Front end:* 100% of app screens, enhancing features/animations, *Back end:* game customization, stretch goals |
| 8 & 9 | Stretch goals, presentation slides + script|
| 10 | Practice presentation, final touches|
| 11 | Presentation Night!! 🕺|

## Tech Stack 💻
Wireframing: [Figma](https://www.figma.com/)  
Front-end: [Flutter](https://docs.flutter.dev/get-started/install)   
Back-end: Dart & [Firebase](https://firebase.google.com/)   
 
## Helpful Resources/Tutorials 📚
Installation & Set Up:  
[Flutter Installation for Mac OS](https://www.youtube.com/watch?v=fzAg7lOWqVE)    
[Installation guide pt 2 for Mac OS](https://www.youtube.com/playlist?list=PL82uaKJraAII8HJjA98l-M6qb_teI97kW)  
[Flutter Installation for Windows](https://www.youtube.com/watch?v=5JBlvjH8ChA)  
[Flutter Installation for Windows pt 2](https://www.youtube.com/watch?v=fDnqXmLSqtg)  
[Firebase w/ Flutter Set Up](https://www.youtube.com/watch?v=EXp0gq9kGxI&t=15s)  
[Install Android Studios](https://developer.android.com/studio/install?gclid=CjwKCAiAuOieBhAIEiwAgjCvcjwYSPTJuW9nn167xix8BzL8KzlDuCIwczz-JaqpBWLl1LyPWHwV1xoCWf0QAvD_BwE&gclsrc=aw.ds#mac)  
[VS Code](https://code.visualstudio.com/download)  

Tutorials/Helpful Links:  
[Flutter Tutorial](https://www.youtube.com/playlist?list=PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ)  
[Flutter Tutorial pt 2](https://www.youtube.com/watch?v=C-fKAzdTrLU&t=1866s)
[Figma Tutorial](https://www.youtube.com/watch?v=FTFaQWZBqQ8)  
[Dart Tutorial](https://www.youtube.com/watch?v=veMhOYRib9o&t=812s)  
[Git Tutorial](https://www.youtube.com/watch?v=USjZcfj8yxE)  
[Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)  
[Firebase CRUD](https://www.youtube.com/watch?v=ErP_xomHKTw)

[How to implement push notifications with Flutter and Firebase Cloud Messaging](https://www.youtube.com/watch?v=AUU6gbDni4Q)
[Push notifications pt 2](https://www.youtube.com/watch?v=--PQXg_mx9I)
    
API links  
- [Google Maps API for Flutter](https://pub.dev/packages/google_maps_flutter) / [Live Location on Flutter](https://medium.com/@samra.sajjad0001/real-time-location-on-map-in-flutter-a-comprehensive-guide-with-coding-examples-5960fc64d342)  
-  [GMaps for Flutter](https://www.youtube.com/watch?v=LnZyorDeLmQ)   
-   [Working with REST APIs - Flutter](https://blog.codemagic.io/rest-api-in-flutter/)

Stretch Goal Resources 
[How to implement the chat feature using Flutter and Firebase](https://www.youtube.com/watch?v=Qwk5oIAkgnY)

Quick Read :)  
[How to be Successful in Projects](https://docs.google.com/document/d/18Zi3DrKG5e6g5Bojr8iqxIu6VIGl86YBSFlsnJnlM88/edit)

## GitHub Cheat Sheet 🗿


| Command | Description |
| ------ | ------ |
| **cd "PickUP"** | Change directories over to our repository |
| **git branch** | Lists branches for you |
| **git branch "branch name"** | Makes new branch |
| **git checkout "branch name"** | Switch to branch |
| **git checkout -b "branch name"** | Same as 2 previous commands together |
| **git add .**| Finds all changed files |
| **git commit -m "Testing123"** | Commit with message |
| **git push origin "branch"** | Push to branch |
| **git pull origin "branch"** | Pull updates from a specific branch |
| get commit hash (find on github or in terminal run **git log --oneline** ) then **git revert 2f5451f --no-edit**| Undo a commit that has been pushed |
| **git reset --soft HEAD~** | Undo commit (not pushed) but *keep* the changes |
| get commit hash then **git reset --hard 2f5451f** | Undo commit (not pushed) and *remove*  changes |

## Developers 👥  
Taaha Hussain 🏎️    
Ahmed Siddiqui ⚽️    
Deston Muo 🏀    
Isha Rao 🎾  

Safa Mohammed - *Project Manager*  
Royce Mathews - *Industry Mentor*
