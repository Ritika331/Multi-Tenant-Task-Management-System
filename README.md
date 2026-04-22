# Multi-Tenant-Task-Management-System

## Team Project

This project has been developed collaboratively by a team of two members as part of a backend-focused full stack system.
**Team Members:**
- Ritika Srivastava
- Md Asad Anwer

## Overview 

This project is a backend-focused Multi-Tenant Task Management System built using Spring Boot. 
The system supports multiple organizations where each organization can manage its own users and tasks.
The primary focus of this project is backend architecture, API design, and data integrity. 

## Backend features  

### Multi-Tenancy Implementation 

-Tenant identification using X-ORG-ID request header 
-Custom tenant context handling per request 
-Strict validation to prevent cross-organization access 
-All services and queries are tenant-aware 

### Rest API Design 

-Organization APIs (create, list) 
-User APIs (tenant-bound user creation)
-Task API:
o	Create task 
o	Assign task to user 
o	Update task 
o	Delete task 
o	Paginated task listing 

### Architecture 

-Clean layered structure:
o	Controller handles HTTP requests
o	Service contains business logic 
o	Repository handles database operations 
-DTO-based communication (no direct entity exposure)
-Separation of concerns maintained throughout 

### Data Integrity and Validation

-Input Validation using Jakarta Validation 
-Global exception handling for consistent error responses
-Tenant-level validation for: 
o	User assignment 
o	Task Access 
o	Data ownership 

### Database Design 

-PostgreSQL integration using Spring Data JPA 
-Entity relationships:
o	Organisation->Users->Tasks 
-Foreign key constraints ensuring consistency

## Tech Stack

-Java, Spring Boot 
-Spring Data JPA 
-PostgreSQL
-React (for basic UI integration) 
-Maven 

## What Makes This Project Strong 

-Real implementation of multi-tenancy (not just theory) 
-Backend-first design approach 
-Secure and isolated data handling 
-Structured API design with validation and error handling 

## Team Contributions

This project was built collaboratively:

**Ritika Srivastava** 

-Developed backend modules for Organization, User, and Task management
-Implemented multi-tenancy using request-based tenant context(X-ORG-ID)
-Designed service-layer logic for task creation, assignment, and updates
-Contributed to validation handling and global exception management
-Participated in database design and entity relationship structuring.

**MD Asad Anwer** 

-Developed backend service logic and contributed to API implementation
-Worked on database schema design and entity relationships(Organization-User-Task)
-Implemented validation checks and supported tenant-based request handling
-Contributed to exception handling and backend flow Refinement
-Participated in testing, debugging, and improving API behavior

Development was done through continuous discussion share to debugging and joint decision making 

## Conclusion 

This project demonstrates strong backend fundamentals including 
-Multi-tenant system design 
-Clean architecture 
-Secure data handling 
-API-driven development 
It reflects how real backend systems enforce data isolation in multi organization environments

