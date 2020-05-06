# Secure Store API & Database Project (Project In Progress)
> A useful application for managing and securely storing credentials, connection strings, tokens, and variables within a SQL Server Database.


## Content
- [Overview](#Overview)
- [API List](#Available-API-Methods)
- [Deployment Process](#Deployment-Process)


<!-- toc -->

## Overview
### Description
A common issues many developers face when implementing new solutions, is being able to manage sensitive information securely and easily. With many companies moving towards a Microservices architecture maintaining both pre-existing and newly developed services could become very difficult especially with updating hard coded service accounts. Utilizing this project applications can easily obtain and set the required sensitive information without having it live inside the application. There are already services out there that provide these same services such as Azure Key Vault. It is recommended that, if available, cloud based services should be utilized over the following project as they are far more stable and built for larger use.


- Pros
  * Being able to update service accounts easily

- Cons
  * Applications will have a strong Dependeny on the Secure Store Services

### Uses

### Requirements
- SQL Server Installation 
  * **_This Project was only build to work with SQL Server and no other DBMS (Database Management System)_**
- IIS COnfiguration /or Azure App Services

### Warnings & Considerations
- It's recommended NOT to deploy this current version on a Network accessible to the internet which is outside your private domain. Even with the data securely encrypted there is still risk of a data leak.
- If using Encryption by Passpharase it's recommended to change the passpharse on a month to month bases.


## Available API Methods
|Http Method|API URI|
|-----------|-------|
|GET|/ConnectionString/Return?|
|PUT|/ConnectionString/Edit?|
|POST|/ConnectionString/Create?|
|DELETE|/ConnectionString/Remove?|
|GET|/Credentials/Return?|
|PUT|/Credentials/Edit?|
|POST|/Credentials/Create?|
|DELETE|/Credentials/Remove?|
|GET|/Token/Return?|
|PUT|/Token/Edit?|
|POST|/TokenCreate?|
|DELETE|/Token/Remove?|
|GET|/Variable/Return?|
|PUT|/Variable/Edit?|
|POST|/Variable/Create?|
|DELETE|/Variable/Remove?|


## Deployment Process
### Step 1 : Database Deployment
Before deploying the application you will need to deploy the database which will securely store your information using a Symmetric Key Encryption by Password. This method can be changed to use certificate based encryption or 
