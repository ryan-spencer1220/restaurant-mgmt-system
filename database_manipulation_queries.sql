-- Get all customer details for the Customers page.
-- This pulls up each customer’s ID, name, email, phone number, and table preference.
-- Staff can see all customer profiles at once, which helps with tracking regulars and knowing customer preferences.
SELECT customerID, firstName, lastName, email, phoneNumber, tablePreference 
FROM Customers;

-- Get all reservations and associated customer names for the Reservations page.
-- By joining Reservations and Customers, we get a clear view of each reservation: who booked it, for when, and with how many guests.
-- This helps staff manage bookings without overbooking or missing reservations.
SELECT Reservations.reservationID, Reservations.customerID, Reservations.tableID, 
       Reservations.reservationDate, Reservations.reservationTime, Reservations.partySize, 
       Reservations.reservationStatus, 
       CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName
FROM Reservations
INNER JOIN Customers ON Reservations.customerID = Customers.customerID
ORDER BY Reservations.reservationDate, Reservations.reservationTime;

-- Get all table details for the Tables page.
-- Shows each table’s ID, section, type, size, and current availability.
-- Helps the staff track available tables quickly so they can seat guests without delays.
SELECT tableID, tableSection, tableType, tableSize, availabilityStatus 
FROM Tables
ORDER BY tableSection, tableType;

-- Get all staff member details for the Staff page.
-- This query lists each staff member's info: ID, name, contact info, and role.
-- It’s a handy way for managers to keep track of everyone on the team.
SELECT staffID, firstName, lastName, phoneNumber, email, staffRole 
FROM Staff
ORDER BY lastName, firstName;

-- Get all schedules for the Schedules page.
-- This retrieves all shifts, including date, start/end times, and type of shift.
-- Managers can easily check coverage for each shift, ensuring they’re fully staffed.
SELECT scheduleID, scheduleDate, scheduleStart, scheduleEnd, scheduleType 
FROM Schedules
ORDER BY scheduleDate, scheduleStart;

-- Get one customer’s data for the Update Customer form.
-- Retrieves details of a single customer using their ID, so the Update Customer form can be pre-filled.
-- Makes updating easier without re-entering all their info.
SELECT customerID, firstName, lastName, email, phoneNumber, tablePreference 
FROM Customers 
WHERE customerID = :customerID_selected_from_customer_page;

-- Get a single reservation’s details for the Update Reservation form.
-- Fetches a specific reservation’s details, so staff can make edits like changing time or party size.
SELECT reservationID, customerID, tableID, reservationDate, reservationTime, 
       partySize, reservationStatus 
FROM Reservations 
WHERE reservationID = :reservationID_selected_from_reservation_page;

-- Get a single table’s details for the Update Table form.
-- Fetches current details for a table (section, type, size, availability) to make quick adjustments.
SELECT tableID, tableSection, tableType, tableSize, availabilityStatus 
FROM Tables 
WHERE tableID = :tableID_selected_from_table_page;

-- Get a single staff member’s details for the Update Staff form.
-- Pulls up one staff member’s info so managers can update their contact details or role if needed.
SELECT staffID, firstName, lastName, phoneNumber, email, staffRole 
FROM Staff 
WHERE staffID = :staffID_selected_from_staff_page;

-- Get a single schedule's details for the Update Schedule form.
-- Shows details for a particular schedule to make it easy to adjust shift times or shift type.
SELECT scheduleID, scheduleDate, scheduleStart, scheduleEnd, scheduleType 
FROM Schedules 
WHERE scheduleID = :scheduleID_selected_from_schedule_page;

-- Add a new customer with relevant details.
-- Inserts a new customer’s name, contact info, and preferred table location, so they’re registered in the system.
INSERT INTO Customers (firstName, lastName, email, phoneNumber, tablePreference) 
VALUES (:firstNameInput, :lastNameInput, :emailInput, :phoneNumberInput, :tablePreferenceInput);

-- Add a new reservation with relevant details.
-- Saves all reservation details, like who booked it, for when, and the party size.
-- Keeps bookings organized so there’s no overlap or confusion.
INSERT INTO Reservations (customerID, tableID, reservationDate, reservationTime, partySize, reservationStatus) 
VALUES (:customerIDInput, :tableIDInput, :reservationDateInput, :reservationTimeInput, :partySizeInput, :reservationStatusInput);

-- Add a new table.
-- Adds a table to the database with its section, type, seating size, and current availability.
-- Important for keeping track of all seating options in the restaurant.
INSERT INTO Tables (tableSection, tableType, tableSize, availabilityStatus) 
VALUES (:tableSectionInput, :tableTypeInput, :tableSizeInput, :availabilityStatusInput);

-- Add a new staff member.
-- Saves a new staff member’s details like name, contact info, and role, helping management track their team.
INSERT INTO Staff (firstName, lastName, phoneNumber, email, staffRole) 
VALUES (:firstNameInput, :lastNameInput, :phoneNumberInput, :emailInput, :staffRoleInput);

-- Add a new schedule.
-- Stores new shift information (date, start/end times, and type of shift) to keep the shift plan organized.
INSERT INTO Schedules (scheduleDate, scheduleStart, scheduleEnd, scheduleType) 
VALUES (:scheduleDateInput, :scheduleStartInput, :scheduleEndInput, :scheduleTypeInput);

-- Update an existing customer’s details based on the Update Customer form.
-- Edits customer info like name, contact details, or preferred table location to keep records current.
UPDATE Customers 
SET firstName = :firstNameInput, lastName = :lastNameInput, email = :emailInput, 
    phoneNumber = :phoneNumberInput, tablePreference = :tablePreferenceInput 
WHERE customerID = :customerID_from_update_form;

-- Update an existing reservation based on the Update Reservation form.
-- Lets staff make updates to a reservation like changing time, party size, or status if there are adjustments.
UPDATE Reservations 
SET customerID = :customerIDInput, tableID = :tableIDInput, reservationDate = :reservationDateInput, 
    reservationTime = :reservationTimeInput, partySize = :partySizeInput, reservationStatus = :reservationStatusInput 
WHERE reservationID = :reservationID_from_update_form;

-- Update an existing table based on the Update Table form.
-- Allows quick updates to table details, such as section, type, or availability, to keep seating info accurate.
UPDATE Tables 
SET tableSection = :tableSectionInput, tableType = :tableTypeInput, 
    tableSize = :tableSizeInput, availabilityStatus = :availabilityStatusInput 
WHERE tableID = :tableID_from_update_form;

-- Update an existing staff member based on the Update Staff form.
-- Updates a staff member’s info, such as role or contact details, keeping the employee list up-to-date.
UPDATE Staff 
SET firstName = :firstNameInput, lastName = :lastNameInput, phoneNumber = :phoneNumberInput, 
    email = :emailInput, staffRole = :staffRoleInput 
WHERE staffID = :staffID_from_update_form;

-- Update an existing schedule based on the Update Schedule form.
-- Allows managers to adjust shift details like timing or shift type to keep scheduling organized.
UPDATE Schedules 
SET scheduleDate = :scheduleDateInput, scheduleStart = :scheduleStartInput, 
    scheduleEnd = :scheduleEndInput, scheduleType = :scheduleTypeInput 
WHERE scheduleID = :scheduleID_from_update_form;

-- Removes a customer from the system using their unique ID, keeping the list clean and current.
DELETE FROM Customers 
WHERE customerID = :customerID_selected_for_delete;

-- Deletes a reservation entry using its ID, helpful if a customer cancels or needs to reschedule.
DELETE FROM Reservations 
WHERE reservationID = :reservationID_selected_for_delete;

-- Removes a table entry by its ID, useful if tables are reconfigured or removed.
DELETE FROM Tables 
WHERE tableID = :tableID_selected_for_delete;

-- Removes a staff member from the records using their ID, helping keep employee records accurate.
DELETE FROM Staff 
WHERE staffID = :staffID_selected_for_delete;

-- Deletes a shift by its ID, used when a shift needs to be removed from the schedule.
DELETE FROM Schedules 
WHERE scheduleID = :scheduleID_selected_for_delete;

-- Links a staff member to a specific schedule, useful for shift planning.
INSERT INTO staffSchedules (staffID, scheduleID) 
VALUES (:staffIDInput, :scheduleIDInput);

-- Removes a staff member’s association with a particular shift, helping adjust schedules.
DELETE FROM staffSchedules 
WHERE staffID = :staffID_selected AND scheduleID = :scheduleID_selected;

-- Links a staff member to a specific table, great for setting up seating assignments.
INSERT INTO staffTables (staffID, tableID) 
VALUES (:staffIDInput, :tableIDInput);

-- Removes a staff member’s association with a particular table, useful if seating arrangements change.
DELETE FROM staffTables 
WHERE staffID = :staffID_selected AND tableID = :tableID_selected;

-- Pulls customer IDs and full names so they can be selected when making a reservation.
SELECT customerID, CONCAT(firstName, ' ', lastName) AS customerName 
FROM Customers;

-- Fetches table IDs and sections for selection when choosing a table for a new reservation.
SELECT tableID, tableSection 
FROM Tables 
WHERE availabilityStatus = 'Available';

-- Loads staff IDs and names so managers can assign specific staff to shifts.
SELECT staffID, CONCAT(firstName, ' ', lastName) AS staffName 
FROM Staff;

-- Pulls all shift details to help managers assign shifts to staff members.
SELECT scheduleID, scheduleDate, scheduleStart, scheduleEnd, scheduleType 
FROM Schedules;

-- Below are some of more advanced queries that deal with deeper analytics 

-- Get the most popular table sections based on how many were linked to completed reservations  
SELECT Tables.tableSection, COUNT(*) AS reservationCount
FROM Reservations
INNER JOIN Tables ON Reservations.tableID = Tables.tableID
WHERE Reservations.reservationStatus = 'Completed'
GROUP BY Tables.tableSection
ORDER BY reservationCount DESC;

-- Get the busiest times for dining by counting reservations per hour.
-- This will help managers make adjustments to manage peak hours, such as assigning more staff during those hours, etc
SELECT reservationTime, COUNT(*) AS reservationCount
FROM Reservations
WHERE reservationStatus = 'Booked'
GROUP BY reservationTime
ORDER BY reservationCount DESC;

-- Track the most frequent customers based on the number of reservations
-- Will help managers when we offer discounts, loyalty program, deals, etc 
SELECT Customers.customerID, CONCAT(Customers.firstName, ' ', Customers.lastName) AS customerName, 
       COUNT(Reservations.reservationID) AS reservationCount
FROM Customers
INNER JOIN Reservations ON Customers.customerID = Reservations.customerID
GROUP BY Customers.customerID, customerName
ORDER BY reservationCount DESC;


