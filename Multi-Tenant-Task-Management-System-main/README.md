**# Multi-Tenant Task Management System**



**## Overview**



**The Multi-Tenant Task Management System is a backend-focused application built using Java, Spring Boot, Spring Data JPA, and PostgreSQL. It enables multiple organizations to manage their users and tasks while maintaining organization-level data isolation.**



**The project demonstrates REST API development, database integration, JWT authentication, input validation, exception handling, and layered backend architecture.**



**## Features**



**- Organization creation and retrieval**

**- User creation and organization-specific user retrieval**

**- Task creation, assignment, updating, deletion, and paginated retrieval**

**- Tenant-aware operations and organization-level access validation**

**- JWT-based authentication**

**- Input validation using Jakarta Validation**

**- Centralized exception handling**

**- DTO-based request and response handling**

**- PostgreSQL integration using Spring Data JPA**



**## Technology Stack**



**- Language: Java**

**- Backend Framework: Spring Boot**

**- Security: Spring Security and JWT**

**- Database: PostgreSQL**

**- ORM: Spring Data JPA**

**- Validation: Jakarta Validation**

**- Build Tool: Maven**

**- Frontend: React**

**- API Architecture: REST**



**## Project Architecture**



**The application follows a layered architecture:**



**- \*\*Controller Layer:\*\* Handles HTTP requests and responses.**

**- \*\*Service Layer:\*\* Contains business logic and tenant-level validation.**

**- \*\*Repository Layer:\*\* Manages database operations using Spring Data JPA.**

**- \*\*Entity Layer:\*\* Represents database tables and relationships.**

**- \*\*DTO Layer:\*\* Defines API request and response structures.**

**- \*\*Security Layer:\*\* Handles JWT authentication and security configuration.**

**- \*\*Tenant Layer:\*\* Maintains the current organization's context.**

**- \*\*Exception Layer:\*\* Handles application errors centrally.**



**## Database Design**



**The application uses PostgreSQL to store organization, user, and task information.**



**- One organization can have multiple users.**

**- One organization can have multiple tasks.**

**- Each task belongs to an organization.**

**- A task can optionally be assigned to a user.**

**- Task statuses include `TODO`, `IN\_PROGRESS`, and `DONE`.**



**Spring Data JPA manages entity mapping and database persistence.**



**## Multi-Tenancy and Security**



**The application uses a tenant context to identify the organization associated with an authenticated request.**



**1. The JWT authentication filter processes the authentication token.**

**2. The organization ID from the token is stored in `TenantContext`.**

**3. Tenant-aware services use the tenant ID for organization-specific operations.**

**4. Task ownership and assigned-user organization membership are validated.**

**5. The tenant context is cleared after request processing.**



**These checks help prevent unauthorized cross-organization access to task data.**



**## API Endpoints**



**- `POST /tasks` - Create a task.**

**- `GET /tasks` - Retrieve paginated tasks.**

**- `PUT /tasks/{taskId}` - Update a task.**

**- `DELETE /tasks/{taskId}` - Delete a task.**

**- `/organizations` - Organization management endpoints.**

**- `/users` - User management endpoints.**

**- `/auth` - Authentication endpoints.**



**The exact routes and HTTP methods for organization, user, and authentication operations are defined in their respective controllers.**



**## Getting Started**



**### Prerequisites**



**- Java Development Kit (JDK)**

**- Maven**

**- PostgreSQL**

**- Node.js and npm**



**### 1. Clone the Repository**



&#x20;   **git clone https://github.com/Ritika331/Multi-Tenant-Task-Management-System.git**

&#x20;   **cd Multi-Tenant-Task-Management-System**



**### 2. Configure the Database**



**Create a PostgreSQL database and configure the database URL, username, password, and other required settings in the backend's `application.properties` file.**



**### 3. Run the Backend**



**Navigate to the backend directory:**



&#x20;   **cd taskmanagement**



**Build the application:**



&#x20;   **mvn clean install**



**Start the application:**



&#x20;   **mvn spring-boot:run**



**### 4. Run the Frontend**



**Open a separate terminal and navigate to the frontend directory:**



&#x20;   **cd taskmanagement-frontend**



**Install dependencies:**



&#x20;   **npm install**



**Start the development server:**



&#x20;   **npm run dev**



**Open the local URL displayed in the terminal.**



**## Testing**



**The APIs can be tested using Postman or another REST API client.**



**Suggested test scenarios include:**



**- Creating and retrieving organizations.**

**- Creating users within an organization.**

**- Creating and assigning tasks.**

**- Updating and deleting tasks.**

**- Retrieving tasks with pagination.**

**- Testing cross-organization task access restrictions.**

**- Validating user assignments.**

**- Testing authentication and invalid requests.**



**## Team Contributions**



**### Ritika Srivastava**



**- Developed backend modules for organization, user, and task management.**

**- Implemented tenant-aware task operations using `TenantContext` and organization-level access validation.**

**- Developed task creation, assignment, update, deletion, and paginated retrieval functionality.**

**- Contributed to DTO design, request validation, and centralized exception handling.**



**### Md Asad Anwer**



**- Contributed to relational database schema design and entity relationships.**

**- Worked on backend service logic and REST API integration.**

**- Contributed to authentication and security configuration.**

**- Performed API testing, debugging, and validation of application behavior and data integrity.**



**## Future Enhancements**



**- Role-based permissions for organization administrators and users.**

**- Improved user onboarding and password management.**

**- Automated unit and integration testing.**

**- Task filtering, sorting, and advanced search.**

**- Production deployment with monitoring.**



**## Project Objective**



**The objective of this project is to demonstrate practical backend engineering skills through a multi-tenant task management application, focusing on maintainable architecture, organization-level data isolation, REST API design, and reliable database operations.**



**## Repository**



**GitHub: https://github.com/Ritika331/Multi-Tenant-Task-Management-System**

