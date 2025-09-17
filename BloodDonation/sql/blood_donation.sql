-- Drop tables if they exist
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS requests;
DROP TABLE IF EXISTS donor_profile;
DROP TABLE IF EXISTS users;

-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('donor', 'patient', 'admin') NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- DONOR PROFILE TABLE
CREATE TABLE donor_profile (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    blood_type VARCHAR(5) NOT NULL,
    city VARCHAR(50),
    last_donation_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- REQUESTS TABLE
CREATE TABLE requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    donor_id INT,
    blood_type_needed VARCHAR(5) NOT NULL,
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    fulfilled BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (donor_id) REFERENCES donor_profile(donor_id) ON DELETE SET NULL
);

-- NOTIFICATIONS TABLE
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    read_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Sample Data

INSERT INTO users (username, password, role, full_name, email) VALUES 
('donor_john', 'hashedpassword1', 'donor', 'John Doe', 'john@example.com'),
('donor_sara', 'hashedpassword2', 'donor', 'Sara Lee', 'sara@example.com'),
('patient_mike', 'hashedpassword3', 'patient', 'Mike Ross', 'mike@example.com');

INSERT INTO donor_profile (user_id, blood_type, city, last_donation_date) VALUES
(1, 'A+', 'New York', '2025-07-10'),
(2, 'O-', 'Los Angeles', '2025-08-01');

INSERT INTO requests (patient_id, donor_id, blood_type_needed, fulfilled) VALUES
(3, NULL, 'A+', FALSE);

INSERT INTO notifications (user_id, message, read_status) VALUES
(1, 'You have a new blood donation request in your area.', FALSE),
(3, 'Your blood request has been created.', FALSE);