# Daredevil 

## Daredevil: converting intention to action
Dust off your bucket lists and start transforming those pipe dreams into concrete plans and actions! But Daredevil isn't just an adventure app. If you are overwhelmed by your long-term goals, Daredevil is here to help you make incremental progress. Daredevil motivates action, encouraging users to accomplish one challenge at a time, whether it be an outdoorsy adrenaline rush like skydiving, a wellness goal like learning to cook a new healthy dish, or career-oriented goals that feel too daunting.

## How it works
Our app asks users to input a set of challenges, and each day, Daredevil generates a random, uncompleted challenge. We dare you to tackle one of your challenges today, but if you don't finish, no problem! Tomorrow is a new day, and a completely different challenge to provide a clean slate and to keep users on their feet. It might take multiple days or (weeks etc.) to complete a challenge depending on its nature, but Daredevil emphasizes progress over immediate results. This app keeps you accountable by sending reminders throughout the day. Once a user marks a daily challenge as complete and their set of challenges dwindles below a threshold, Daredevil asks for more challenges as input. 

## Frontend
**Login**
<p float="left">
  <img src="/readme_img/login.png" width="200" />
</p>

**Input new challenges & see all challenges**
<p float="left">
  <img src="/readme_img/newGoal.png" width="200" /> 
  <img src="/readme_img/allGoal.png" width="208" />
</p>

**See daily goal and mark complete goal.**
<p float="left">
  <img src="/readme_img/dailygoal.png" width="200" />
  <img src="/readme_img/completegoal.png" width="203">
</p>


Our project is built with Swift using the SwiftUI framework. We used Model-View-View Model architectural pattern and URLSession for Networking. We currently have 4 views but are working on adding more. We used Figma to design our views.

## Backend

We used SQLAlchemy to represent our database in the backend. We implemented a one-to-many relationship in our database file and 12 endpoints (5 endpoints for token-based authentication, 7 for app functionality). We developed API’s using the Flask framework, and we employed Postman for testing our endpoints. Lastly, we used Docker and Google Cloud Services for deploying our code into a publicly accessible API (with an IP address of 34.145.190.118). 

## Challenges & Hopes
Some challenges we faced include designing the views for the frontend on Figma. This was the moment where we realized and fully appreciated just how much planning and informed decision-making goes on behind the scenes of today’s most popular apps and their sleek designs. We focused on simplicity and straightforward navigation for our UI, but we hope to make our views more visually appealing in the future. We also faced numerous concurrency issues while integrating the backend and frontend together. We hope to strengthen authorization in the future, and hopefully include some web-scraping functionality/AI component to help generate fun activities for people who are blanking on what challenges they want to give themselves. 

## Collaborators
Bellerina Hu (bh552@cornell.edu) – full-stack   
Aileen Huang (aeh245@cornell.edu) – full-stack   
Both – design

## Credits
Cornell AppDev Intro to Backend Development Course  
Cornell AppDev Intro to iOS Development Course  
iOS Academy channel on Youtube
