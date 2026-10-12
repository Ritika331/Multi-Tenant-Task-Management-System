# Multi-Tenant Task Management System

A backend-focused task management application built with Java, Spring Boot, Spring Data JPA, and PostgreSQL. The application supports multiple organizations, enabling them to manage their users and tasks with organization-level data isolation.

## Features

- **Organization Management:** Create and retrieve organizations.
- **User Management:** Create users and retrieve users belonging to the current organization.
- **Task Management:** Create, assign, update, delete, and retrieve tasks.
- **Multi-Tenancy:** Maintain organization-specific context for tenant-aware operations.
- **Access Validation:** Validate task ownership and user assignment across organizations.
- **JWT Authentication:** Process authenticated requests using JSON Web Tokens.
- **Pagination:** Retrieve tasks in paginated results.
- **Input Validation:** Validate incoming request data.
- **Exception Handling:** Handle application errors centrally.
- **DTO-Based APIs:** Use Data Transfer Objects for request and response handling.

## Technology Stack

- Java
- Spring Boot
- Spring Security
- Spring Data JPA
- PostgreSQL
- JWT Authentication
- Jakarta Validation
- Maven
- React
- REST APIs

## Project Architecture

The backend follows a layered architecture to separate responsibilities and improve maintainability.

- **Controller:** Handles HTTP requests and responses.
- **Service:** Implements business logic and tenant-level validation.
- **Repository:** Performs database operations using Spring Data JPA.
- **Entity:** Represents database tables and relationships.
- **DTO:** Defines API request and response structures.
- **Security:** Handles JWT authentication and security configuration.
- **Tenant:** Maintains the current organization's context.
- **Exception:** Provides centralized exception handling.

## Database Design

The application uses PostgreSQL to store organization, user, and task information.

- An organization can have multiple users.
- An organization can have multiple tasks.
- Each task belongs to an organization.
- A task can optionally be assigned to a user.
- Task statuses include `TODO`, `IN_PROGRESS`, and `DONE`.

Spring Data JPA manages entity mapping and database persistence.

## Multi-Tenancy

The application uses a tenant context to identify the organization associated with an authenticated request.

1. The JWT authentication filter processes the authentication token.
2. The organization ID from the authenticated token is stored in `TenantContext`.
3. Tenant-aware services use the tenant ID for organization-specific operations.
4. Task ownership and assigned-user organization membership are validated.
5. The tenant context is cleared after request processing.

These checks help prevent unauthorized cross-organization access to task data.

## API Endpoints

### Task Management

- `POST /tasks` — Create a task.
- `GET /tasks` — Retrieve paginated tasks.
- `PUT /tasks/{taskId}` — Update a task.
- `DELETE /tasks/{taskId}` — Delete a task.

### Other Modules

- `/organizations` — Organization management.
- `/users` — User management.
- `/auth` — Authentication.

The exact routes and HTTP methods for organization, user, and authentication operations are defined in their respective controllers.

## Getting Started

### Prerequisites

Install the following software before running the application:

- Java Development Kit (JDK)
- Maven
- PostgreSQL
- Node.js and npm

### 1. Clone the Repository

```bash
git clone https://github.com/Ritika331/Multi-Tenant-Task-Management-System.git
cd Multi-Tenant-Task-Management-System
```

### 2. Configure the Database

Create a PostgreSQL database and configure the database connection settings in the backend's `application.properties` file.

Provide the appropriate database URL, username, password, and other required application settings.

### 3. Start the Backend

Navigate to the backend directory:

```bash
cd taskmanagement
```

Build the project:

```bash
mvn clean install
```

Start the application:

```bash
mvn spring-boot:run
```

### 4. Start the Frontend

Open a separate terminal from the project root directory and navigate to the frontend:

```bash
cd taskmanagement-frontend
```

Install the dependencies:

```bash
npm install
```

Start the development server:

```bash
npm run dev
```

Open the local URL displayed in the terminal.

## Testing

Use Postman or another REST API client to test the application's endpoints.

Recommended test scenarios include:

- Creating and retrieving organizations.
- Creating users within an organization.
- Creating and assigning tasks.
- Updating and deleting tasks.
- Retrieving tasks with pagination.
- Validating task ownership and user assignments.
- Testing authentication and invalid requests.
- Verifying cross-organization task access restrictions.

## Team Contributions

### Ritika Srivastava

- Developed backend modules for organization, user, and task management.
- Implemented tenant-aware task operations using `TenantContext` and organization-level access validation.
- Developed task creation, assignment, update, deletion, and paginated retrieval functionality.
- Contributed to DTO design, request validation, and centralized exception handling.

### Md Asad Anwer

- Contributed to relational database schema design and entity relationships.
- Worked on backend service logic and REST API integration.
- Contributed to authentication and security configuration.
- Performed API testing, debugging, and validation of application behavior and data integrity.

## Future Enhancements

- Role-based permissions for organization administrators and users.
- Improved user onboarding and password management.
- Automated unit and integration testing.
- Task filtering, sorting, and advanced search.
- Production deployment with monitoring.

## Repository

[Multi-Tenant Task Management System on GitHub](https://github.com/Ritika331/Multi-Tenant-Task-Management-System)
