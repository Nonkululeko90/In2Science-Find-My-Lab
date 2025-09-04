-- This SQL schema represents the foundational data model for the IN2SCIENCE MVP.

-- Users table to store information about all user types.
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserType ENUM('Workplace', 'ESP', 'Commercial Client', 'Admin') NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    CompanyName VARCHAR(255),
    PhoneNumber VARCHAR(20),
    ProfileStatus ENUM('Active', 'Pending Verification', 'Suspended') DEFAULT 'Active',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ServiceProviders table to store specific details for ESPs.
CREATE TABLE ServiceProviders (
    ProviderID INT PRIMARY KEY,
    LabName VARCHAR(255) NOT NULL,
    Address TEXT,
    Website VARCHAR(255),
    DescriptionOfServices TEXT,
    VerificationStatus ENUM('Verified', 'Not Verified') DEFAULT 'Not Verified',
    FOREIGN KEY (ProviderID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- ProviderCredentials to store and manage verification documents for ESPs.
CREATE TABLE ProviderCredentials (
    CredentialID INT PRIMARY KEY AUTO_INCREMENT,
    ProviderID INT NOT NULL,
    CredentialName VARCHAR(255) NOT NULL, -- e.g., 'ISO 17025'
    DocumentURL VARCHAR(255) NOT NULL,
    VerificationDate DATE,
    ExpiryDate DATE,
    FOREIGN KEY (ProviderID) REFERENCES ServiceProviders(ProviderID) ON DELETE CASCADE
);

-- Services table allows providers to list their specific analytical offerings.
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY AUTO_INCREMENT,
    ProviderID INT NOT NULL,
    ServiceName VARCHAR(255) NOT NULL, -- e.g., 'Gas Chromatography'
    ServiceDescription TEXT,
    FOREIGN KEY (ProviderID) REFERENCES ServiceProviders(ProviderID) ON DELETE CASCADE
);

-- JobPostings table for clients to post their service needs.
CREATE TABLE JobPostings (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT NOT NULL,
    JobTitle VARCHAR(255) NOT NULL,
    JobDescription TEXT NOT NULL,
    IsEmergency BOOLEAN DEFAULT FALSE,
    RequiredTimeline VARCHAR(100),
    Status ENUM('Open', 'In Progress', 'Completed', 'Canceled') DEFAULT 'Open',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClientID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- A linking table to connect job postings with required services/certifications.
CREATE TABLE JobRequiredServices (
    JobID INT NOT NULL,
    ServiceName VARCHAR(255) NOT NULL,
    PRIMARY KEY (JobID, ServiceName),
    FOREIGN KEY (JobID) REFERENCES JobPostings(JobID) ON DELETE CASCADE
);

-- Messages table for in-app communication.
CREATE TABLE Messages (
    MessageID INT PRIMARY KEY AUTO_INCREMENT,
    SenderID INT NOT NULL,
    ReceiverID INT NOT NULL,
    JobID INT,
    MessageContent TEXT NOT NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SenderID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ReceiverID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (JobID) REFERENCES JobPostings(JobID) ON DELETE CASCADE
);