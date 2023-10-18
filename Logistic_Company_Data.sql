-- CREATE A DATABASE SCHEMA
CREATE DATABASE Logistic_Company;

-- USE CLAUSE IS USED TO RECALL THE DATABASE
USE Logistic_Company;

-- CREATE TABLE RELATIONSHIPS THAT CAN BE USED IN ANY TECHNOLOGY

-- CREATE TABLE employee_details (
-- 						E_ID INT PRIMARY KEY, 
--                         E_NAME VARCHAR(30), 
--                         E_DESIGNATION VARCHAR(40), 
--                         E_ADDR VARCHAR(100), 
--                         E_BRANCH VARCHAR(15), 
--                         E_CONT_NO INT);
                        
-- CREATE TABLE membership (
-- 					M_ID INT PRIMARY KEY, 
--                     Start_date DATE, 
--                     End_date DATE);

-- CREATE TABLE customer (
-- 					   C_ID INT PRIMARY KEY,
-- 					   M_ID INT,
--                     C_NAME VARCHAR(30), 
--                     C_EMAIL_ID VARCHAR(50), 
--                     C_TYPE VARCHAR(30), 
--                     C_ADDR VARCHAR(100), 
--                     C_CONT_NO INT,
-- 					   FOREIGN KEY(M_ID) REFERENCES membership(M_ID));
                    
-- CREATE TABLE payment_details (
-- 						Payment_ID VARCHAR(40) PRIMARY KEY, 
--                         C_ID INT, 
--                         SH_ID VARCHAR(6), 
--                         AMOUNT INT, 
--                         Payment_Status VARCHAR(10), 
--                         Payment_Mode VARCHAR(25), 
--                         Payment_Date date,
--                         FOREIGN KEY (C_ID) REFERENCES customer(C_ID));

-- CREATE TABLE shipment_details (
-- 							SH_ID INT PRIMARY KEY, 
--                             C_ID INT, 
--                             SH_CONTENT VARCHAR(40), 
--                             SH_DOMAIN VARCHAR(15), 
--                             SER_TYPE VARCHAR(15), 
--                             SH_WEIGHT INT, 
--                             SH_CHARGES INT, 
--                             SR_ADDR VARCHAR(100), 
--                             DS_ADDR VARCHAR(100),
--                             FOREIGN KEY (SH_ID) REFERENCES payment_details(SH_ID),
--                             FOREIGN KEY (C_ID) REFERENCES customer(C_ID));

-- CREATE TABLE status (
-- 				SH_ID INT, 
--                 Current_Status VARCHAR(15), 
--                 Sent_date DATE, 
--                 Delivery_date DATE,
--                 FOREIGN KEY (SH_ID) REFERENCES shipment_details(SH_ID),
--                 FOREIGN KEY (SH_ID) REFERENCES payment_details(SH_ID));

-- CREATE TABLE employee_manages_shipment (
-- 								Employee_E_ID INT, 
-- 								Shipment_Sh_ID INT, 
--                                 Status_Sh_ID INT,
--                                 FOREIGN KEY (Employee_E_ID) REFERENCES employee_details(E_ID),
--                                 FOREIGN KEY (Shipment_Sh_ID) REFERENCES shipment_details(SH_ID),
--                                 FOREIGN KEY (Status_Sh_ID) REFERENCES status(SH_ID)); 


SELECT * FROM customer;
SELECT * FROM employee_details;	
SELECT * FROM employee_manages_shipment;
SELECT * FROM membership;
SELECT * FROM payment_details;
SELECT * FROM shipment_details;
SELECT * FROM status;

-- QUERY OR TASK

-- 1. Count the customer base based on customer type to identify current customer preference and sort in descending order.
SELECT C_TYPE, COUNT(C_TYPE) AS Customer_Type_Count
FROM customer
GROUP BY C_TYPE
ORDER BY Customer_Type_Count DESC;

-- 2. Count the customer base based on their status of payment in descending order.
SELECT Payment_Status, COUNT(C_ID) AS PS_COUNTS
FROM payment_details
GROUP BY Payment_Status
ORDER BY PS_COUNTS DESC;

-- 3. Count the customer base based on their payment mode in descending order of count.
SELECT Payment_Mode, COUNT(C_ID) AS PM_COUNTS
FROM payment_details
GROUP BY Payment_Mode
ORDER BY PM_COUNTS DESC;

-- 4. Count the customers as per shipment domain in descending order.

SELECT SH_DOMAIN, COUNT(C_ID) AS SHD_COUNTS
FROM shipment_details
GROUP BY SH_DOMAIN
ORDER BY SHD_COUNTS DESC;

-- 5. Count the customer according to service type in descending order of count.
SELECT SER_TYPE, COUNT(C_ID) AS SER_TYP_COUNTS
FROM shipment_details
GROUP BY SER_TYPE
ORDER BY SER_TYP_COUNTS DESC;

-- 6. Explore employee count based on designation-wise count of employee's ID in descending order.
SELECT E_DESIGNATION, COUNT(E_ID) AS EMP_COUNTS
FROM employee_details
GROUP BY E_DESIGNATION
ORDER BY EMP_COUNTS DESC;

-- 7. Branch-wise count of employees for efficiency of deliveries in descending order.
SELECT E_BRANCH, COUNT(E_ID) AS EMP_BR_COUNTS
FROM employee_details
GROUP BY E_BRANCH
ORDER BY EMP_BR_COUNTS DESC;

-- 8. Finding C_ID, M_ID, and tenure for those customers whose membership is over 10 years.
SELECT C_ID, c.M_ID, m.M_ID, (End_date - Start_date) AS Tenure
FROM customer AS c
JOIN membership AS m on c.M_ID = m.M_ID
WHERE (End_date - Start_date) > 10
ORDER BY Tenure DESC;

-- 9. Considering average payment amount based on customer type having payment mode as COD in descending order.
SELECT c.C_ID, C_TYPE, Payment_Mode, AVG(AMOUNT) AS AVG_Amount 
FROM customer AS c
Join payment_details AS pd on c.C_ID = pd.C_ID
Where Payment_Mode = 'COD'
GROUP BY C_TYPE
ORDER BY AVG_Amount DESC;

-- 10. Calculate the average payment amount based on payment mode where payment date is not null.
SELECT Payment_Mode, Payment_Date, AVG(AMOUNT) AS AVG_Amount
FROM payment_details
Where Payment_Date IS NOT NULL
GROUP BY Payment_Mode IS NOT NULL;

-- 11. Calculate the average shipment weight based on payment_status where shipment content does not start with "H."
SELECT Payment_Status, AVG(SH_WEIGHT) AS AVG_SH_Weight
FROM shipment_details AS sd
JOIN payment_details AS pd on sd.SH_ID = pd.SH_ID
Where SH_CONTENT NOT LIKE 'H%'
GROUP BY Payment_Status;