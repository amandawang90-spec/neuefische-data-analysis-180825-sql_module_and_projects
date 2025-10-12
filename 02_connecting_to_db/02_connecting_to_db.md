# Connecting to PostgreSQL Database

###  Objectives:
- DBeaver setup
- Connection to a Database in AWS 



## 1. Server-Client Model

PostgreSQL databases operate on a server-client model. The **server** hosts the databases, managing data storage, manipulation, and security. **Clients** are applications or tools that connect to the server to request data. They send queries to the server, which processes them and returns the results.

Some common PostgreSQL clients include:

- **psql**: A command-line tool that comes with PostgreSQL.
- **PgAdmin**: A popular graphical client for managing PostgreSQL databases.
- **DBeaver**: A universal database tool (supports PostgreSQL, but not only)
- **DataGrip**: A database IDE from JetBrains (supports PostgreSQL, but not only)
- **Tableau**: A business intelligence tool that can connect to PostgreSQL for data analysis.

	>**SQL Client / Database IDE**
	>
	>- IDE = **I**ntegrated **D**evelopment **E**nvironment
	>- Powerful software that can be used to connect to a database and retrieve and visualise data (and more!)
	>- Local or in the cloud
	>- Open-source, free and paid software is available



## 2. DBeaver Setup

![img](./images/dbeaver_logo.png)



In this course we will use DBeaver

**DBeaver** is a powerful desktop sql editor, integrated development environment (IDE) and it has a graphical user interface  (GUI) for databases (not only postgres).

>### ➥ Download and install [DBeaver](https://dbeaver.io/download/)



## 3. Connecting to a **PostgreSQL** database in AWS

1. Click on “New Database Connection” 
2. Download Driver (if necessary)
3. Search for and select PostgreSQL
4. Enter the connection details below

![db_connection](./images/db_connection.png)


| Syntax      | Description |
| ----------- | ----------- |
| **Host**      | data-analytics-course-2.c8g8r1deus2v.eu-central-1.rds.amazonaws.com       |
| **Port**   | 5432        |
| **Database**   | cohort_name (depending on your cohort setup) |
| **Username**   | Will be sent to you via e-mail / posted in Slack/Zoom Chat        |
| **Password**   | Will be sent to you via e-mail / posted in Slack/Zoom Chat        |



## 4. Editor Settings (optional)


#### Open DBeaver > Window > Preferences  

- Enable upper case: 

  ​	**Editors > SQL Editor > Formatting > Keyword Case >** Set to: 'Upper'

- Disable/Enable Auto-Convert to preset keyword case:  
  **Editors > SQL Editor > Code Editor > Convert keyword case >** Tick box

- Disable Auto-Completion:  
  **Editors > SQL Editor > Code Completion > Enable auto activation >** Tick box

- When keeping Auto-Completion, define the Case to use:  
    **Editors > SQL Editor > Code Completion > Insert Case >** Select 'Upper case' from the drop box

- Add line numbers: 

  ​	**Editors > Text Editors > Show line numbers >** Tick box

