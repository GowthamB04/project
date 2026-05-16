CREATE DATABASE IF NOT EXISTS claim_management_db;
USE claim_management_db;

CREATE TABLE IF NOT EXISTS companies (
  company_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  company_name VARCHAR(255) NOT NULL UNIQUE,
  account_number VARCHAR(100) NOT NULL,
  ifsc_code VARCHAR(50),
  bank_name VARCHAR(200),
  address VARCHAR(500),
  account_balance DOUBLE
);

CREATE TABLE IF NOT EXISTS users (
  user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  full_name VARCHAR(200) NOT NULL,
  password VARCHAR(200) NOT NULL,
  email VARCHAR(200) NOT NULL UNIQUE,
  phone_number VARCHAR(50) NOT NULL,
  date_of_birth DATE,
  address VARCHAR(500),
  account_number VARCHAR(100) NOT NULL,
  ifsc_code VARCHAR(50) NOT NULL,
  bank_name VARCHAR(200),
  company_id BIGINT,
  role VARCHAR(50) NOT NULL,
  account_status VARCHAR(50) NOT NULL,
  created_at DATETIME,
  last_login DATETIME,
  CONSTRAINT fk_user_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE IF NOT EXISTS insurance_policies (
  policy_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  policy_number VARCHAR(100) NOT NULL UNIQUE,
  policy_name VARCHAR(255) NOT NULL,
  policy_type VARCHAR(100),
  coverage_amount DOUBLE,
  premium_amount DOUBLE,
  benefits TEXT,
  policy_status VARCHAR(50),
  start_date DATE,
  end_date DATE,
  created_at DATETIME,
  updated_at DATETIME
);

CREATE TABLE IF NOT EXISTS hospitals (
  hospital_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  hospital_name VARCHAR(255) NOT NULL,
  hospital_type VARCHAR(100),
  address VARCHAR(500),
  phone_number VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS doctors (
  doctor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  doctor_name VARCHAR(255) NOT NULL,
  specialization VARCHAR(200),
  qualification VARCHAR(200),
  experience_years INT,
  hospital_id BIGINT,
  CONSTRAINT fk_doctor_hospital FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

CREATE TABLE IF NOT EXISTS treatments (
  treatment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  diagnosis VARCHAR(500),
  treatment_description TEXT,
  treatment_amount DOUBLE,
  treatment_date DATE,
  user_id BIGINT,
  doctor_id BIGINT,
  hospital_id BIGINT,
  CONSTRAINT fk_treatment_user FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT fk_treatment_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
  CONSTRAINT fk_treatment_hospital FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

CREATE TABLE IF NOT EXISTS claims (
  claim_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  claim_number VARCHAR(150) NOT NULL UNIQUE,
  claim_amount DOUBLE,
  approved_amount DOUBLE,
  claim_status VARCHAR(50),
  approver_comment TEXT,
  rejection_reason TEXT,
  claim_date DATE,
  user_id BIGINT,
  policy_id BIGINT,
  treatment_id BIGINT,
  assigned_to_id BIGINT,
  approved_by_id BIGINT,
  approved_date DATETIME,
  CONSTRAINT fk_claim_user FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT fk_claim_policy FOREIGN KEY (policy_id) REFERENCES insurance_policies(policy_id),
  CONSTRAINT fk_claim_treatment FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id),
  CONSTRAINT fk_claim_assigned_to FOREIGN KEY (assigned_to_id) REFERENCES users(user_id),
  CONSTRAINT fk_claim_approved_by FOREIGN KEY (approved_by_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS documents (
  document_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  document_name VARCHAR(255) NOT NULL,
  document_type VARCHAR(100),
  document_path VARCHAR(500),
  uploaded_date DATE,
  claim_id BIGINT,
  CONSTRAINT fk_document_claim FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);

CREATE TABLE IF NOT EXISTS payments (
  payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  payment_amount DOUBLE,
  payment_date DATETIME,
  payment_mode VARCHAR(100),
  transaction_id VARCHAR(200),
  payment_status VARCHAR(50),
  claim_id BIGINT,
  user_id BIGINT,
  CONSTRAINT fk_payment_claim FOREIGN KEY (claim_id) REFERENCES claims(claim_id),
  CONSTRAINT fk_payment_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO companies (company_name, account_number, ifsc_code, bank_name, address, account_balance)
VALUES
  ('Insurance Corp', '9999000011110001', 'ICICI000000', 'Insurance Bank', 'Company HQ Address', 10000000);

INSERT INTO users (username, full_name, password, email, phone_number, date_of_birth, address, account_number, ifsc_code, bank_name, company_id, role, account_status, created_at, last_login)
VALUES
  ('admin.user', 'Admin User', '$2a$10$/93IBKVYANyRhvEHF0F83.L0.fp/4CRbeewgrsWmSAo6iqaqBkQci', 'admin@insurance.com', '9000000001', '1980-01-01', 'Admin Address', '1111000011110001', 'HDFC0000001', 'HDFC Bank', 1, 'ADMIN', 'ACTIVE', NOW(), NULL),
  ('approver1', 'Approver One', '$2a$10$p6YakPBd6UWxQZtscdJ5geOL7TR3iedzb3o6ly1wtffYeYivvPCku', 'approver1@insurance.com', '9000000002', '1985-02-05', 'Approver Address', '2222000022220002', 'HDFC0000002', 'HDFC Bank', 1, 'APPROVER', 'ACTIVE', NOW(), NULL),
  ('approver2', 'Approver Two', '$2a$10$.8dhImc1Qt.3Sus87VzDWecDrTr56RvsU/bHvRS9iOnftyFCPvu6G', 'approver2@insurance.com', '9000000003', '1986-04-10', 'Approver Address', '2222000022220003', 'HDFC0000003', 'HDFC Bank', 1, 'APPROVER', 'ACTIVE', NOW(), NULL),
  ('policyholder1', 'Policyholder One', '$2a$10$STmZ88L5qJJYZybqxeD5XOYFdEpmpV6SurYxyJKtAMLgTq1PEt9yq', 'policyholder1@insurance.com', '9000000004', '1990-03-10', 'Policyholder Address 1', '3333000033330001', 'HDFC0000004', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder2', 'Policyholder Two', '$2a$10$1lS4vFo/Uuwsw.iterDxReBKYn3hURr/J5xRRyIwCe06siLrI.hOC', 'policyholder2@insurance.com', '9000000005', '1991-04-11', 'Policyholder Address 2', '3333000033330002', 'HDFC0000005', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder3', 'Policyholder Three', '$2a$10$agpoAsCxbUzTKY/hixU2neRC95mqqQDonFF.nLCaJSd7PmWPHYseW', 'policyholder3@insurance.com', '9000000006', '1992-05-12', 'Policyholder Address 3', '3333000033330003', 'HDFC0000006', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder4', 'Policyholder Four', '$2a$10$7U4U2LbtOeXFjjIhXajyqe7/KlOzjs76k2wtFPY2URNhkhPbOHXde', 'policyholder4@insurance.com', '9000000007', '1993-06-13', 'Policyholder Address 4', '3333000033330004', 'HDFC0000007', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder5', 'Policyholder Five', '$2a$10$0nvSwrSrzljUXW8Fu5hgFeRT2O0WtOlGA2AYZhy7EKtq.Lg556jFW', 'policyholder5@insurance.com', '9000000008', '1994-07-14', 'Policyholder Address 5', '3333000033330005', 'HDFC0000008', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder6', 'Policyholder Six', '$2a$10$GRZBkmlJLuURCjb2/7H1dedMngaCZx5MKBGWWWXtS/cn8zULMYfnS', 'policyholder6@insurance.com', '9000000009', '1995-08-15', 'Policyholder Address 6', '3333000033330006', 'HDFC0000009', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder7', 'Policyholder Seven', '$2a$10$TYTYPDvc5G5VhoMCck4MbeoApDSrfJBxeIuTGgmXfxroZpkdni2HS', 'policyholder7@insurance.com', '9000000010', '1996-09-16', 'Policyholder Address 7', '3333000033330007', 'HDFC0000010', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder8', 'Policyholder Eight', '$2a$10$FD3znC2X5cnXXRpZLeEIXeKZ3F3RFVZfWLE31czdvT4.gj/s4KznK', 'policyholder8@insurance.com', '9000000011', '1997-10-17', 'Policyholder Address 8', '3333000033330008', 'HDFC0000011', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder9', 'Policyholder Nine', '$2a$10$.Kfs.cb2RXPE9oFFHl2.0eScyFHArmXXoOmrxx/UErwZKBNCPsTz.', 'policyholder9@insurance.com', '9000000012', '1998-11-18', 'Policyholder Address 9', '3333000033330009', 'HDFC0000012', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL),
  ('policyholder10', 'Policyholder Ten', '$2a$10$azBHXTl2v4HTB215WyToauRPmQuK6ZHeXJPj6Ue.K3IIx9ItGrgd2', 'policyholder10@insurance.com', '9000000013', '1999-12-19', 'Policyholder Address 10', '3333000033330010', 'HDFC0000013', 'HDFC Bank', 'POLICYHOLDER', 'ACTIVE', NOW(), NULL);

INSERT INTO insurance_policies (policy_number, policy_name, policy_type, coverage_amount, premium_amount, benefits, policy_status, start_date, end_date, created_at, updated_at)
VALUES
  ('HP-2026-001', 'Health Protect Plus', 'Family', 500000, 7500, 'Hospitalization, Surgery, Daycare', 'ACTIVE', '2026-06-01', '2027-06-01', NOW(), NOW());

INSERT INTO hospitals (hospital_name, hospital_type, address, phone_number)
VALUES
  ('Sunrise General Hospital', 'Multi Speciality', '123 Health Avenue, City', '9876543210');

INSERT INTO doctors (doctor_name, specialization, qualification, experience_years, hospital_id)
VALUES
  ('Dr. Meera Sharma', 'Cardiology', 'MBBS, MD', 12, 1);

INSERT INTO treatments (diagnosis, treatment_description, treatment_amount, treatment_date, user_id, doctor_id, hospital_id)
VALUES
  ('Gallbladder infection', 'Laparoscopic surgery and recovery', 85000, '2026-06-10', 4, 1, 1);

INSERT INTO claims (claim_number, claim_amount, approved_amount, claim_status, approver_comment, rejection_reason, claim_date, user_id, policy_id, treatment_id)
VALUES
  ('CLAIM-1001', 85000, 0, 'PENDING', NULL, NULL, '2026-06-15', 4, 1, 1);

INSERT INTO documents (document_name, document_type, document_path, uploaded_date, claim_id)
VALUES
  ('Hospital Bill', 'BILL', '/uploads/bills/bill-1001.pdf', '2026-06-15', 1),
  ('Prescription', 'PRESCRIPTION', '/uploads/prescriptions/prescription-1001.pdf', '2026-06-15', 1);

INSERT INTO payments (payment_amount, payment_date, payment_mode, transaction_id, payment_status, claim_id, user_id)
VALUES
  (0, '2026-06-15 00:00:00', 'NEFT', '', 'INITIATED', 1, 4);
