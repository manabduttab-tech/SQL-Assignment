create database ASSIGNMENt;
use ASSIGNMENT;

CREATE TABLE Customers (
CustomerID INT,
CustomerName VARCHAR(50),
City VARCHAR(30),
JoinDate DATE);

INSERT INTO Customers VALUES
(101,'Rahul Sharma','Bangalore','2023-01-15'),
(102,'Priya Mehta','Mumbai','2024-03-20'),
(103,'Arjun Nair','Chennai','2025-01-12'),
(104,'Sneha Gupta','Delhi','2022-07-10'),
(105,'Kavya Reddy','Hyderabad','2024-08-15'),
(106,'Amit Verma','Pune','2023-11-05'),
(107,'Rohan Singh','Kolkata','2024-05-18'),
(108,'Simran Kaur','Delhi','2025-02-01'),
(109,'Anjali Jain','Mumbai','2023-09-22'),
(110,'Vikram Patel','Ahmedabad','2022-12-30');
select * from Customers;

CREATE TABLE Orders (
OrderID INT,
CustomerID INT,
OrderDate DATE,
OrderAmount DECIMAL(10,2),
Status VARCHAR(20));

INSERT INTO Orders VALUES
(5001,101,'2025-01-05',12000,'Delivered'),
(5002,102,'2025-01-15',8500,'Pending'),
(5003,101,'2025-02-10',22000,'Delivered'),
(5004,104,'2025-02-15',4500,'Cancelled'),
(5005,103,'2025-03-01',17500,'Delivered'),
(5006,105,'2025-03-10',9800,'Pending'),
(5007,106,'2025-03-18',25000,'Delivered'),
(5008,107,'2025-04-02',14500,'Delivered'),
(5009,101,'2025-04-10',30000,'Delivered'),
(5010,109,'2025-04-15',6500,'Pending'),
(5011,110,'2025-05-01',42000,'Delivered'),
(5012,104,'2025-05-08',18000,'Delivered'),
(5013,106,'2025-05-15',7000,'Cancelled'),
(5014,102,'2025-05-20',27000,'Delivered'),
(5015,107,'2025-06-01',15500,'Pending');
select * from Orders;

CREATE TABLE Employees (
EmployeeID INT,
EmployeeName VARCHAR(50),
ManagerID INT,
Department VARCHAR(30),
JoiningDate DATE,
Salary DECIMAL(10,2));

INSERT INTO Employees VALUES
(1,'Rajesh Kumar',NULL,'Management','2018-01-10',150000),
(2,'Neha Sharma',1,'Sales','2020-03-15',90000),
(3,'Amit Gupta',1,'IT','2019-06-20',110000),
(4,'Priyanka Singh',2,'Sales','2022-01-12',65000),
(5,'Vikas Patel',2,'Sales','2021-09-18',70000),
(6,'Rohit Jain',3,'IT','2023-02-05',60000),
(7,'Anjali Verma',3,'IT','2022-11-10',62000),
(8,'Karan Mehta',1,'HR','2021-05-25',80000),
(9,'Sneha Kapoor',8,'HR','2024-01-05',50000),
(10,'Arjun Malhotra',3,'IT','2024-04-15',55000);
select * from employees;

	##Q1-solution

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderAmount AS order_value
FROM 
    orders as o
INNER JOIN 
    customers as c ON o.CustomerID = c.CustomerID
ORDER BY 
    o.OrderAmount DESC
LIMIT 5;

	##Q2-solution

SELECT CustomerID, CustomerName
FROM customers
WHERE LEFT(CustomerName, 1) IN ('A', 'R', 'S');

	##Q3-solution

SELECT 
    c.CustomerName AS "Customer Name",
    o.OrderID AS "Order ID",
    o.OrderAmount AS "Order Amount",
    o.Status AS "Status"
FROM 
    customers as c
JOIN 
    orders as o ON c.CustomerID = o.CustomerID
WHERE 
    o.OrderAmount > 10000 AND o.Status = 'Pending';
    
	##Q4-solution
    
SELECT 
    CustomerID, 
    CustomerName, 
    JoinDate,
    CURRENT_DATE - JoinDate AS Days_Associated 
FROM customers
WHERE 
    (CURRENT_DATE - JoinDate) > 365
ORDER BY Days_Associated DESC;
    
	##Q5-solution
    
SELECT 
    OrderID AS "Order ID",
    OrderAmount AS "Current Amount",
    (OrderAmount * 0.18) AS "18% GST",
    (OrderAmount * 1.18) AS "Total Amount After GST",
    DATE_ADD(OrderDate, INTERVAL 15 DAY) AS "Expected Collection Date"
FROM orders;

	##Q6-solution

SELECT
	CustomerID,
    SUM(OrderAmount) AS total_order_value
FROM orders
GROUP BY CustomerID
ORDER BY total_order_value DESC
LIMIT 10 OFFSET 10;

	##Q7-solution
    
SELECT 
    CustomerID AS "Customer ID",
    CustomerName AS "Customer Name",
    JoinDate AS "Join Date",
    DATEDIFF(curdate(), JoinDate) AS "{Number of Days Since Registration"
FROM 
    Customers
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM Orders 
        WHERE Orders.CustomerID = Customers.CustomerID);
        
        ##Q8-solution
        
SELECT
	EmployeeName AS "Employee Name",
    ManagerID AS "Manager Name",
    Department
FROM employees;

        ##Q9-solution

WITH FirstOrders AS (
    SELECT 
        CustomerID,
        MIN(OrderDate) AS first_order_date
    FROM 
        orders
    GROUP BY 
        CustomerID)
SELECT 
    c.CustomerName AS "Customer Name",
    c.JoinDate AS "Join Date",
    f.first_order_date AS "Order Date",
    (f.first_order_date - c.JoinDate) AS "Days Taken To Place First Order"
FROM 
    customers as c
JOIN 
    FirstOrders as f ON c.CustomerID = f.CustomerID
WHERE 
    (f.first_order_date - c.JoinDate) <= 30
ORDER BY 
    "Days Taken To Place First Order" ASC;

        ##Q10-solution
        
SELECT 
    c.CustomerName AS "Customer Name",
    SUM(o.OrderAmount) AS "Total Purchase Amount",
    CASE 
        WHEN SUM(o.OrderAmount) > 50000 THEN 'Premium'
        WHEN SUM(o.OrderAmount) BETWEEN 20000 AND 50000 THEN 'Gold'
        ELSE 'Silver'
    END AS "Spending Category",
    CASE 
        WHEN c.JoinDate < '2024-01-01' THEN 'Loyal Customer'
        ELSE 'New Customer'
    END AS "Loyalty Status"
FROM 
    customers as c
JOIN 
    orders as o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, 
    c.CustomerName, 
    c.JoinDate;
    
        ##Q11-solution
        
SELECT 
    c.CustomerName AS "Customer Name",
    o.OrderID AS "Order ID",
    o.OrderAmount AS "Order Amount"
FROM 
    orders as o
JOIN 
    customers as c ON o.CustomerID = c.CustomerID
WHERE 
    o.OrderAmount > (SELECT AVG(OrderAmount) FROM orders);
    
        ##Q12-solution
        
SELECT 
    c.CustomerName AS "Customer Name", 
    o.OrderID AS "Order ID", 
    o.OrderAmount AS "Order Amount"
FROM 
    orders as o
JOIN 
    customers as c ON o.CustomerID = c.CustomerID 
ORDER BY 
    o.OrderAmount DESC
LIMIT 5 OFFSET 1;