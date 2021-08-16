# Syllabus-System
Web system that allows the creation and management of course syllabuses and their related information.

<b>Description:</b><br>
The purpose of this project is to provide an integrated system that provides a set of tools that helps the designated personal to visualize, create, modify, and manage class syllabuses, helping them to align course objectives with the standards imposed by the different accrediting agencies, and reducing the paperwork. <br>
The application main objectives are:<br>
1. Allow administrative personal have control and records of each class syllabus created for each program.
2. Allow the distribution of class syllabuses to professors.
3. Allow the creation of programs and courses.
4. Allow updates to each syllabus.
5. Provide a tool to align the course objective to the standards of each accrediting agency. 
6. Minimize archives of physical class syllabuses currently stored.
7. Provide a search capability by course programs and by course codes.
8. Add class rules.


<b>Functional Requirements:</b><br>
1. The user must have the option after finding the desired syllabus to download it.
2. The programs of studies will be divided by bachelor's degree, master's degree, and doctorate.
3. Each syllabus must be able to be viewed once found.
4. The structure of each syllabus when viewed must be the same structure in which the user can download the syllabus.
5. User inputs for every field in the application must be regulated for a specific task by validation.
6. The user must be able to perform all actions inside the application without downloading any files to the computer, apart from the syllabus download option where the selected syllabus is downloaded to the computer.
7. The objective section of each syllabus will be made in a table.
8. Administrative staff must be allowed to add new programs to the system. 
9. Administrative staff must be allowed to add new courses to the system.
10. Administrative staff must be allowed to add new course rules to the system.
11.	Administrative staff must be able to add the courses to the programs.
12.	The user must have the option to search for a specific syllabus by hovering over a search bar and entering course codes or course names or part of them.

<b>Security Requirements:</b><br>
1.	Users’ passwords must be hashed with the correct parameters for protection.
2.	Each user of the application must include their full name.
3.	If a user does not have permissions for certain pages or actions, the web page must not allow interaction of the user and if they try to access a restricted area for them, the system redirects them to the login.

<b>Presentation Requirements</b><br>
1. The implementation must be web-based running on modern web browsers for windows such as Chrome.
2. The university logo must be present through the application.
3. Links, buttons, and other interactive tags must have a visual border to identify differences from the rest of the web.
4. When a syllabus is edited it must be considered that page size may increment or decrease, changing the position of elements to print and show.
5. The web colors must match those of the institution or with similar shades.

<b>Performance Requirements</b><br>
1. The algorithms need to be design aiming to provide the least waiting time to the user.
2. There must be a help page that depending on where the aid is requested, help corresponding to that area will be shown.

<b>Information regarding the database:</b><br>
The generateDB.sql is the script that you should run for a newly created application and will not have any inserts. For the initial inserts, you need to run the populateDB.sql script. <br>
The entity–relationship model is presented below:<br>
![image](https://user-images.githubusercontent.com/84880545/129573048-ed09f3db-6e1c-430e-864d-5cceb4b1ff56.png)


<b>Page-flow information:</b><br>
The page flow indicates where you can go from a specific web page and the required condition to be able to move to that page. The page-flow is in the file page_flow.drawio and you need to use the following web site to open it, https://app.diagrams.net/ <br> There you will select File -> Open from -> Device and then search where you download the file.

<b>Remarks:</b><br>
1. The classes folder goes inside ROOT/WEB-INF directory in Tomcat.
2. Remember to add the classpath information in the environment variables.
3. Add the required libraries in the lib directory in Tomcat.
4. The Pages' Prototypes does not go inside Tomcat, they are only for general overview of the interface design without the need of the web server.
5. The syllabusSystem directory goes inside the ROOT folder in Tomcat.
6. The structure and names of folders and files should not be modified. The only files that can be deleted are the two examples of file generation.

<h1>This project is for educational purposes only!</h1>
Copyright Disclaimer under section 107 of the Copyright Act 1976, allowance is made for “fair use” for purposes such as criticism, comment, news reporting, teaching, scholarship, education and research.
Non-profit or educational use leans the balance in favor of fair use.
