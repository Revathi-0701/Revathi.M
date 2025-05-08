create database hospital;
use hospital;
# create table for patients
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Phone VARCHAR(15),
    Address TEXT,
    RegistrationDate DATE
);
# create table for Doctors 
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Specialty VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    HireDate DATE
);
# create table for Rooms 
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomType VARCHAR(50),
    Availability BOOLEAN DEFAULT TRUE
);
# create table for Appointments
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Reason TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
# create table for Admissions
CREATE TABLE Admissions (
    AdmissionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    RoomID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- create table for Bills 
CREATE TABLE Bills (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);
# insert table for Patients
INSERT INTO Patients (FullName, Gender, DateOfBirth, Phone, Address, RegistrationDate) VALUES
('John Doe', 'Male', '1985-07-12', '1234567890', '123 Main Street', '2025-01-10'),
('Jane Smith', 'Female', '1990-03-22', '0987654321', '456 Oak Avenue', '2025-02-05');
select * from Patients;
# insert table for Doctors
INSERT INTO Doctors (FullName, Specialty, Phone, Email, HireDate) VALUES
('Dr. Alice Brown', 'Cardiologist', '1112223333', 'alice@example.com', '2020-05-01'),
('Dr. Bob White', 'Pediatrician', '4445556666', 'bob@example.com', '2021-06-15');
select * from Doctors;
# insert table for Rooms
INSERT INTO Rooms (RoomType, Availability) VALUES
('General', TRUE),
('ICU', TRUE);
select * from Rooms;
#insert table for Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(1, 1, '2025-03-15 10:00:00', 'Chest pain'),
(2, 2, '2025-03-16 14:30:00', 'Child fever');
select * from Appointments;
# insert table for Admissions
INSERT INTO Admissions (PatientID, RoomID, AdmissionDate, DischargeDate) VALUES
(1, 1, '2025-03-15', '2025-03-18'),
(2, 2, '2025-03-16', NULL);
select * from Admissions;
# insert table for Bills
INSERT INTO Bills (PatientID, Amount, PaymentDate, PaymentMethod) VALUES
(1, 5000.00, '2025-03-19', 'Cash'),
(2, 7500.00, '2025-03-20', 'Credit Card');
select * from Bills;
# display all patients with appoinment
SELECT P.FullName, A.AppointmentDate, D.FullName AS Doctor
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID;

# display the Total bills by patient
SELECT PatientID, SUM(Amount) AS TotalBill
FROM Bills
GROUP BY PatientID;
# display the availablity rooms
SELECT * FROM Rooms WHERE Availability = TRUE;
# display the currently admitted patients
SELECT P.FullName, A.AdmissionDate, R.RoomType
FROM Admissions A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Rooms R ON A.RoomID = R.RoomID
WHERE A.DischargeDate IS NULL;
CREATE VIEW View_Appointments AS
SELECT 
    A.AppointmentID,
    P.FullName AS PatientName,
    D.FullName AS DoctorName,
    D.Specialty,
    A.AppointmentDate,
    A.Reason
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID;
# View: Current Admissions (DischargeDate IS NULL)
CREATE VIEW View_CurrentAdmissions AS
SELECT 
    P.FullName AS PatientName,
    R.RoomType,
    A.AdmissionDate
FROM Admissions A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Rooms R ON A.RoomID = R.RoomID
WHERE A.DischargeDate IS NULL;
# View: Billing Summary by Patient
CREATE VIEW View_BillingSummary AS
SELECT 
    P.FullName,
    SUM(B.Amount) AS TotalAmountPaid
FROM Bills B
JOIN Patients P ON B.PatientID = P.PatientID
GROUP BY P.FullName;
#View Doctor Schedule (Upcoming Appointments)
CREATE VIEW View_DoctorSchedule AS
SELECT 
    D.FullName AS DoctorName,
    D.Specialty,
    A.AppointmentDate,
    P.FullName AS PatientName
FROM Appointments A
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Patients P ON A.PatientID = P.PatientID
WHERE A.AppointmentDate >= CURRENT_DATE()
ORDER BY A.AppointmentDate;
#using subqueries
# patients who paid more than average bill
SELECT FullName
FROM Patients
WHERE PatientID IN (
    SELECT PatientID
    FROM Bills
    GROUP BY PatientID
    HAVING SUM(Amount) > (
        SELECT AVG(Amount) FROM Bills
    )
);
# Doctors Who had appoinment Today
SELECT FullName
FROM Doctors
WHERE DoctorID IN (
    SELECT DoctorID
    FROM Appointments
    WHERE DATE(AppointmentDate) = CURRENT_DATE()
);
# patients with no bills
select FullName from Patients where PatientID Not in(select distinct PatientID from Bills);
drop table admissions;
drop table rooms;

