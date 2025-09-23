-- Create Database
CREATE DATABASE IF NOT EXISTS blood_donation_db;
USE blood_donation_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role ENUM('donor', 'patient', 'admin') NOT NULL,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Donor Profile Table
CREATE TABLE IF NOT EXISTS donor_profile (
    donor_id INT PRIMARY KEY,
    blood_group VARCHAR(5) NOT NULL,
    age INT,
    gender VARCHAR(10),
    last_donation_date DATE,
    availability ENUM('available','not_available') DEFAULT 'available',
    FOREIGN KEY (donor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Requests Table
CREATE TABLE IF NOT EXISTS requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    donor_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_date TIMESTAMP NULL,
    FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (donor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    status ENUM('unread', 'read') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Dummy Users (Donors & Patients & Admins)
INSERT INTO users (username, password, name, email, phone, role, location)
VALUES
('donor1', 'pass123', 'John Doe', 'john1@example.com', '111-111-1111', 'donor', 'New York'),
('donor2', 'pass123', 'Jane Roe', 'jane2@example.com', '222-222-2222', 'donor', 'Boston'),
('donor3', 'pass123', 'Alice Smith', 'alice3@example.com', '333-333-3333', 'donor', 'Chicago'),
('patient1', 'pass123', 'Bob Patient', 'bob1@example.com', '444-444-4444', 'patient', 'New York'),
('patient2', 'pass123', 'Charlie Patient', 'charlie2@example.com', '555-555-5555', 'patient', 'Boston'),
('admin1', 'adminpass', 'Super Admin', 'admin1@example.com', '999-999-9999', 'admin', 'HQ');

-- Dummy Donor Profiles
INSERT INTO donor_profile (donor_id, blood_group, age, gender, last_donation_date, availability)
VALUES
(1, 'A+', 28, 'Male', '2025-06-01', 'available'),
(2, 'B-', 35, 'Female', '2025-05-15', 'available'),
(3, 'O+', 24, 'Female', '2025-03-20', 'not_available');

-- Dummy Requests
INSERT INTO requests (patient_id, donor_id, status, request_date, response_date)
VALUES
(4, 1, 'pending', '2025-09-21 10:00:00', NULL),
(5, 2, 'accepted', '2025-09-20 13:00:00', '2025-09-21 09:00:00'),
(4, 2, 'rejected', '2025-09-19 17:00:00', '2025-09-20 11:00:00');

-- Dummy Notifications
INSERT INTO notifications (user_id, message, status, created_at)
VALUES
(1, 'You have a new blood request from Bob Patient.', 'unread', NOW()),
(4, 'Your request to John Doe is pending.', 'unread', NOW()),
(2, 'Your last request was accepted by Jane Roe.', 'read', NOW());
