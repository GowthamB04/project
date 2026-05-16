# Health Insurance Claim Management System

## Overview
This project is a Spring Boot 4 backend for a Health Insurance Claim Management System. It is built with Java 17, Spring Data JPA, Spring Web, and MySQL.

The system supports three roles:
- `POLICYHOLDER`
- `APPROVER`
- `ADMIN`

Users cannot self-register. Only existing users stored in the database can log in.

## Main Purpose
The project allows a policyholder to submit a medical reimbursement claim, upload supporting documents, and track the claim through approval, rejection, and payment settlement.

## Key Features
- User login with role-based responses
- Policy management by ADMIN
- Hospital and doctor management
- Treatment recording for policyholders
- Claim submission and approval flow
- Document upload metadata tracking
- Payment settlement details

## Project Structure
- `entity` - JPA entity classes
- `repository` - Spring Data JPA repositories
- `service` - service interfaces
- `service/impl` - service implementation classes
- `controller` - REST controllers and APIs

## Setup and Run
1. Configure MySQL database credentials in `src/main/resources/application.properties`:
   - `spring.datasource.url`
   - `spring.datasource.username`
   - `spring.datasource.password`
2. Create the database or use the provided `insert.sql` file.
3. Run the app with Maven:
   - Windows: `./mvnw spring-boot:run`
4. Access the API at `http://localhost:8080`.

## Database
- Database name: `claim_management_db`
- Table schema is managed by JPA with `spring.jpa.hibernate.ddl-auto=update`
- Seed data can be loaded with `insert.sql`
- Admin and approver credentials are linked to the company context. In a complete design this can be represented by a `company` table and company-owned admin/approver accounts.

## Company and payment flow
- Admin and approver users are part of the company domain and should be understood as company staff accounts.
- Admin can view all user details and manage users, policies, hospitals, doctors, claims, and payments.
- Approver can view only the details of the policyholder who raised a claim and the claim’s related treatment information.
- When a claim is approved, the payment amount is sent from the company/admin account to the policyholder user account.
- Payment records connect the approved claim to the recipient user, with the source representing the company.

## Important Endpoints
### Login
- `POST /api/users/login`
- Use `application/x-www-form-urlencoded` or JSON in the request body.
- Do not place username/password in the URL.

- Form data example:
```
username=admin.user
password=Admin@123
```

- JSON example:
```json
{
  "username": "admin.user",
  "password": "Admin@123"
}
```

### Test user accounts
- Admin: `admin.user` / `Admin@123`
- Approver: `approver1` / `ApproverOne@123`
- Approver: `approver2` / `ApproverTwo@123`
- Policyholder 1: `policyholder1` / `Policyholder1@123`
- Policyholder 2: `policyholder2` / `Policyholder2@123`
- Policyholder 3: `policyholder3` / `Policyholder3@123`
- Policyholder 4: `policyholder4` / `Policyholder4@123`
- Policyholder 5: `policyholder5` / `Policyholder5@123`
- Policyholder 6: `policyholder6` / `Policyholder6@123`
- Policyholder 7: `policyholder7` / `Policyholder7@123`
- Policyholder 8: `policyholder8` / `Policyholder8@123`
- Policyholder 9: `policyholder9` / `Policyholder9@123`
- Policyholder 10: `policyholder10` / `Policyholder10@123`

### User management
- Admin can view all users and their details.
- Approver can view only the policyholder user details for claims they are reviewing, including treatment and claim metadata.
- Policyholder can view only their own profile, claims, treatments, and payments.
- `GET /api/users` (Admin only)
- `GET /api/users/{id}` (Admin for all users, Approver for claim raiser details, Policyholder for own record)
- `POST /api/users`
- `PUT /api/users/{id}`
- `PATCH /api/users/{id}`
- `DELETE /api/users/{id}`

### Policy management
- `GET /api/policies`
- `POST /api/policies`
- `PUT /api/policies/{id}`
- `PATCH /api/policies/{id}`

### Hospital and Doctor management
- `GET /api/hospitals`
- `POST /api/hospitals`
- `GET /api/doctors`
- `POST /api/doctors`

### Treatment and Claim flow
- `POST /api/treatments`
- `POST /api/claims`
- `GET /api/claims/{id}`
- `PATCH /api/claims/{id}/approve`

### Documents and Payments
- `POST /api/documents`
- `POST /api/payments`

## Sample Postman Flow
1. Login as `POLICYHOLDER` via `/api/users/login`
2. Create or view policies with `/api/policies`
3. Create hospital and doctor records using `/api/hospitals` and `/api/doctors`
4. Add a treatment record with `/api/treatments`
5. Submit a claim with `/api/claims`
6. Add supporting documents via `/api/documents`
7. Login as `APPROVER` and approve the claim via `PATCH /api/claims/{id}/approve`
8. The approval creates a payment record that links the company/admin account to the policyholder user account

### Approve Claim example
Request:
```json
{
  "approverId": 2,
  "approvedAmount": 85000,
  "approverComment": "Approved after review",
  "paymentMode": "NEFT",
  "transactionId": "TXN123456"
}
```
Response:
```json
{
  "claimId": 1,
  "claimNumber": "CLAIM-1001",
  "claimAmount": 85000,
  "approvedAmount": 85000,
  "claimStatus": "APPROVED",
  "approverComment": "Approved after review",
  "approvedBy": {
    "userId": 2,
    "username": "approver1",
    "fullName": "Approver One",
    "role": "APPROVER"
  },
  "payment": {
    "paymentAmount": 85000,
    "paymentDate": "2026-06-15T00:00:00",
    "paymentMode": "NEFT",
    "transactionId": "TXN123456",
    "paymentStatus": "COMPLETED"
  }
}
```

## Notes
- The backend currently handles entity relationships and basic CRUD operations.
- Claim rejection reasons, approval comments, and approved amounts are stored in claim records.
- Payment information is linked to claim and user records.
- Admin payments represent the company releasing funds to the policyholder after claim approval.
- Passwords are hashed automatically by the backend when users are created or updated.
- Login validates passwords with BCrypt; the backend does not decrypt stored passwords.

## Project explanation for interviews
- This project is a simple health insurance claim management backend built using Spring Boot 4 and MySQL.
- The main actors are `POLICYHOLDER`, `APPROVER`, and `ADMIN`.
- Policyholders submit reimbursement claims with treatment details and supporting documents.
- Approvers verify the claim and treatment details, and can approve or reject the claim.
- Admins manage master data such as users, policies, hospitals, doctors, and company payments.
- The payment flow simulates the company paying the user: once an approver approves a claim, the payment is recorded from the company/admin account to the policyholder user account.
- This keeps the model simple: user login, role-based access, claim workflow, and payment settlement.
- In discussion, explain that the company account is the funding source and approval is the gating step before payment.

## Files Included
- `insert.sql` - SQL to create database and seed sample data
- `post.ms` - API endpoint list and sample request bodies
- `work.txt` - Project description and roles summary
- `README.md` - Setup and usage guide
- `example.txt` - Detailed project flow and annotation explanation
