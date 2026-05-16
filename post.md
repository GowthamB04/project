# Claim Management API Endpoints

## User APIs

POST /api/users/login
- Use `application/x-www-form-urlencoded` or JSON in the request body.
- Do not pass credentials in the URL path.

- Sample form data:
  - `username=admin.user`
  - `password=Admin@123`

- Sample JSON body:
{
  "username": "admin.user",
  "password": "Admin@123"
}

- Response JSON:
{
  "message": "Login successful",
  "role": "ADMIN",
  "user": { ... }
}

### Test accounts
- Admin: `admin.user` / `Admin@123`
- Approver 1: `approver1` / `ApproverOne@123`
- Approver 2: `approver2` / `ApproverTwo@123`
- Policyholder 1: `policyholder1` / `Policyholder1@123`
- Policyholders 2-10: `policyholderX` / `PolicyholderX@123`

GET /api/users
GET /api/users/{id}
POST /api/users
PUT /api/users/{id}
PATCH /api/users/{id}
DELETE /api/users/{id}

### Claim approval
PATCH /api/claims/{id}/approve
- Request body:
{
  "approverId": 2,
  "approvedAmount": 85000,
  "approverComment": "Approved after review",
  "paymentMode": "NEFT",
  "transactionId": "TXN123456"
}
- Response example:
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
- This endpoint is used by APPROVER or ADMIN to approve a claim and trigger a payment from the company account to the policyholder.

## Insurance Policy APIs

GET /api/policies
GET /api/policies/{id}
POST /api/policies
PUT /api/policies/{id}
PATCH /api/policies/{id}
DELETE /api/policies/{id}

## Hospital APIs

GET /api/hospitals
GET /api/hospitals/{id}
POST /api/hospitals
PUT /api/hospitals/{id}
PATCH /api/hospitals/{id}
DELETE /api/hospitals/{id}

## Doctor APIs

GET /api/doctors
GET /api/doctors/{id}
POST /api/doctors
PUT /api/doctors/{id}
PATCH /api/doctors/{id}
DELETE /api/doctors/{id}

## Treatment APIs

GET /api/treatments
GET /api/treatments/{id}
POST /api/treatments
PUT /api/treatments/{id}
PATCH /api/treatments/{id}
DELETE /api/treatments/{id}

## Claim APIs

GET /api/claims
GET /api/claims/{id}
POST /api/claims
PUT /api/claims/{id}
PATCH /api/claims/{id}
DELETE /api/claims/{id}

## Document APIs

GET /api/documents
GET /api/documents/{id}
POST /api/documents
PUT /api/documents/{id}
PATCH /api/documents/{id}
DELETE /api/documents/{id}

## Payment APIs

GET /api/payments
GET /api/payments/{id}
POST /api/payments
PUT /api/payments/{id}
PATCH /api/payments/{id}
DELETE /api/payments/{id}

---

# Sample POST Requests

POST /api/policies
{
  "policyNumber": "HP-2026-001",
  "policyName": "Health Protect Plus",
  "policyType": "Family",
  "coverageAmount": 500000,
  "premiumAmount": 7500,
  "benefits": "Hospitalization, Surgery, Daycare",
  "policyStatus": "ACTIVE",
  "startDate": "2026-06-01",
  "endDate": "2027-06-01"
}

POST /api/hospitals
{
  "hospitalName": "Sunrise General Hospital",
  "hospitalType": "Multi Speciality",
  "address": "123 Health Avenue, City",
  "phoneNumber": "9876543210"
}

POST /api/doctors
{
  "doctorName": "Dr. Meera Sharma",
  "specialization": "Cardiology",
  "qualification": "MBBS, MD",
  "experienceYears": 12,
  "hospital": { "hospitalId": 1 }
}

POST /api/treatments
{
  "diagnosis": "Gallbladder infection",
  "treatmentDescription": "Laparoscopic surgery and recovery",
  "treatmentAmount": 85000,
  "treatmentDate": "2026-06-10",
  "user": { "userId": 1 },
  "doctor": { "doctorId": 1 },
  "hospital": { "hospitalId": 1 }
}

POST /api/claims
{
  "claimNumber": "CLAIM-1001",
  "claimAmount": 85000,
  "approvedAmount": 0,
  "claimStatus": "PENDING",
  "claimDate": "2026-06-15",
  "user": { "userId": 1 },
  "insurancePolicy": { "policyId": 1 },
  "treatment": { "treatmentId": 1 }
}

POST /api/documents
{
  "documentName": "Hospital Bill",
  "documentType": "BILL",
  "documentPath": "/uploads/bills/bill-1001.pdf",
  "uploadedDate": "2026-06-15",
  "claim": { "claimId": 1 }
}

POST /api/payments
{
  "paymentAmount": 80000,
  "paymentDate": "2026-06-20T10:15:00",
  "paymentMode": "NEFT",
  "transactionId": "TXN123456789",
  "paymentStatus": "SUCCESS",
  "claim": { "claimId": 1 },
  "user": { "userId": 1 }
}
