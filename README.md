# FreshWatch
My first Flutter app for registration the amount of vegetables a user eats per day.  
350g of vegetables is the target daily intake in this app.

<img src="https://user-images.githubusercontent.com/58480791/157446674-6ed932a0-cea7-467f-a302-69855908e020.gif" width=300>

## Screenshots
![Screenshot_1646840943](https://user-images.githubusercontent.com/58480791/157477777-be93e509-f3de-4030-8123-1ca84ceab991.png)
![Screenshot_1646840939](https://user-images.githubusercontent.com/58480791/157477668-b45549b1-c622-4324-ae11-b38097795dcf.png)

## Features
#### 🥕 Record of vegetables
The app enables a user to register the name of vegetables they ate, its intake and image.
Of course, a user can also update and delete those.  
The indicator of a daily intake displayed as well.
If the intake reaches 350g, the indicator is filled up to the maximum.

#### 📊 Display weekly intakes in a bar chart
A user can check intakes of vegetables per day in the last week.
Displaying these in a bar chart makes it easy to compare intakes.

#### 🗓 Store all data from oldest to latest
In History Screen, a user can find all data registered.
In Addition, If you sign in with your google account, all data is stored in cloud.

## Architecture
Flutter with Provider for State Management + Firebase for Authentication, DataBase and Storage
