# hw08-aleurcelay

Hello! :raising_hand:

This is the repository of my homework 8 for the [STAT547](http://stat545.com) course.
Instructions for this assignment can be found [here](http://stat545.com/Classroom/assignments/hw08/hw08.html)

For this assignment, I added features to the BC Liquor shiny app. The original code and data for this app are from [Dean Attali's tutorial](https://deanattali.com/blog/building-shiny-apps-tutorial). The code can specifically be found [here](https://deanattali.com/blog/building-shiny-apps-tutorial/#12-final-shiny-app-code).

## The app
To review my assignment, please use the following link to access the app:
:star2:`[]()`


## Features added

### **An image of the BC Liquor store logo**  

<img src="bcl/www/BClogo.png" alt="BCliquorstore" width="200"/> 

### **Interactive table:**  
The table allows the user to sort by any variable from the table in ascending or descending order.  
### **Choose multiple types of alcohol:** 
The user can now select more that one type of alcohol at the same time. 
### **Number of options to get you tipsy ☺:** 
When the user makes some selections of price and/or product type and country of origin a message with the number of results shows up as "We found # options to get you tipsy ☺". 
### **Download option:**
The user can download the current displayed options as a .csv file. 
### **Show results from all countries:** 
The user can decide wether to filter by country of origin or not (show all countries).  
### **Select plot colors:** 
Default colors for each type of alcohol are displayed when opening the app, but the user can change each color by clicking the desired color in the palette, transparency is available so the user can choose any desired color/tone!

## Code
If you want to see my code to generate the app:
[App.R](bcl/app.R)



