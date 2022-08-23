USE classicmodels;
  
-- RENAMING THE CUSTOMERS TABLE
ALTER TABLE customers CHANGE customernumber Customer_ID INT;
ALTER TABLE customers CHANGE customername Company VARCHAR (50);
ALTER TABLE customers CHANGE contactLastName Last_Name VARCHAR (30);
ALTER TABLE customers CHANGE contactfirstname First_Name VARCHAR (30);
ALTER TABLE customers CHANGE phone Phone VARCHAR (30);
ALTER TABLE customers CHANGE addressline1 First_Address VARCHAR (50);
ALTER TABLE customers CHANGE addressline2 Second_Address VARCHAR (50);
ALTER TABLE customers CHANGE city City VARCHAR (30);
ALTER TABLE customers CHANGE state State VARCHAR (50);
ALTER TABLE customers CHANGE postalcode Postal_Code VARCHAR (20);
ALTER TABLE customers CHANGE country Country VARCHAR (30);
ALTER TABLE customers CHANGE salesrepemployeenumber Sales_Rep_ID INT;
ALTER TABLE customers CHANGE creditlimit Credit_Limit DECIMAL (9,2);

-- POSITIONING THE FIRST NAME BEFORE THE LAST NAME IN THE CUSTOMERS TABLE  
ALTER TABLE customers MODIFY Last_Name VARCHAR (30) AFTER First_Name;

-- RENAMING THE EMPLOYEES TABLE 
ALTER TABLE employees CHANGE employeenumber Employee_ID INT;
ALTER TABLE employees CHANGE lastname Last_Name VARCHAR (30);
ALTER TABLE employees CHANGE firstname First_Name VARCHAR (30);
ALTER TABLE employees CHANGE extension Extension VARCHAR (20);
ALTER TABLE employees CHANGE officecode Office_Code VARCHAR (10);
ALTER TABLE employees CHANGE reportsto Reports_To INT;
ALTER TABLE employees CHANGE jobtitle Job_Title VARCHAR (30);

-- POSITIONING THE FIRST NAME BEFORE THE LAST NAME IN THE EMPLOYEES TABLE
ALTER TABLE employees MODIFY Last_Name VARCHAR (30) AFTER First_Name;

-- RENAMING THE OFFICES TABLE
ALTER TABLE offices CHANGE officecode Office_ID INT;
ALTER TABLE offices CHANGE city City VARCHAR (30);
ALTER TABLE offices CHANGE phone Phone VARCHAR (30);
ALTER TABLE offices CHANGE addressline1 First_Address VARCHAR (50);
ALTER TABLE offices CHANGE addressline2 Second_Address VARCHAR (50);
ALTER TABLE offices CHANGE state State VARCHAR (30);
ALTER TABLE offices CHANGE country Country VARCHAR (30);
ALTER TABLE offices CHANGE postalcode Postal_Code VARCHAR (20);
ALTER TABLE offices CHANGE territory Territory VARCHAR (15);

-- RENAMING THE ORDERDETAILS TABLE 
ALTER TABLE orderdetails CHANGE ordernumber Order_ID INT;
ALTER TABLE orderdetails CHANGE productcode Product_ID VARCHAR (30);
ALTER TABLE orderdetails CHANGE quantityordered Quantity_Ordered INT;
ALTER TABLE orderdetails CHANGE priceeach Unit_Price DECIMAL (9,2);
ALTER TABLE orderdetails CHANGE orderlinenumber Order_Line_ID INT;

-- RENAMING THE ORDERS TABLE 
ALTER TABLE orders CHANGE ordernumber Order_ID INT;
ALTER TABLE orders CHANGE orderdate Order_Date DATE;
ALTER TABLE orders CHANGE requireddate Expected_Delivery_Date DATE;
ALTER TABLE orders CHANGE shippeddate Shipped_Date DATE;
ALTER TABLE orders CHANGE status Status VARCHAR (20);
ALTER TABLE orders CHANGE comments Comments VARCHAR (200);
ALTER TABLE orders CHANGE customernumber Customer_ID INT;
ALTER TABLE orders MODIFY order_ID INT AFTER Customer_ID;
ALTER TABLE orders MODIFY Order_Date DATE AFTER Order_ID;
ALTER TABLE orders MODIFY Expected_Delivery_Date DATE AFTER Order_Date;
ALTER TABLE orders MODIFY Shipped_Date DATE AFTER Expected_Delivery_Date;
ALTER TABLE orders MODIFY Status VARCHAR (20) AFTER Shipped_Date;
ALTER TABLE orders MODIFY Comments VARCHAR (200) AFTER Status;
ALTER TABLE orders MODIFY Customer_ID INT AFTER Order_ID;

-- RENAMING THE PAYMENTS TABLE 
ALTER TABLE payments CHANGE customernumber Customer_ID INT;
ALTER TABLE payments CHANGE checknumber Cheque_Number VARCHAR (30);
ALTER TABLE payments CHANGE paymentdate Payment_Date DATE;
ALTER TABLE payments CHANGE amount Amount DECIMAL (15,2);

-- RENAMING THE PRODCUTLINES TABLE 
ALTER TABLE productlines CHANGE productline Product_Line VARCHAR (50);
ALTER TABLE productlines CHANGE textdescription Product_Descripton VARCHAR (4000);

-- DELETE UNWANTED COLUMNS IN THE PRODUCTLINES TABLE
ALTER TABLE productlines DROP COLUMN htmldescription;
ALTER TABLE productlines DROP COLUMN image;

-- RENAMING THE PRODUCTS TABLE 
ALTER TABLE products CHANGE productcode Product_ID VARCHAR (30);
ALTER TABLE products CHANGE productname Product_Name VARCHAR (100);
ALTER TABLE products CHANGE productline Product_Line VARCHAR (50);
ALTER TABLE products CHANGE productscale Product_Scale VARCHAR (10);
ALTER TABLE products CHANGE productvendor Product_Vendor VARCHAR (100);
ALTER TABLE products CHANGE productdescription Product_Description VARCHAR (5000);
ALTER TABLE products CHANGE quantityinstock Quantity_In_Stock VARCHAR (10);
ALTER TABLE products CHANGE buyprice Purchase_Price DECIMAL (9,2);
ALTER TABLE products CHANGE msrp Sale_Price DECIMAL (9,2);

-- LIST OF COUNTRIES WHERE ALL CUSTOMERS ARE LOCATED
SELECT DISTINCT country
FROM Customers;

-- NUMBER OF COUNTRIES WHERE ALL CUSTOMERS ARE LOCATED (27 COUNTRIES)
SELECT COUNT(DISTINCT COUNTRY) COUNTRY
FROM CUSTOMERS;

-- LIST OF CUSTOMERS THAT DO NOT HAVE A SALES REP ASSIGNED TO THEM
SELECT Customer_ID, Company, First_Name, Last_Name, City, Country, Sales_Rep_ID, credit_limit FROM Customers 
WHERE sales_rep_id IS NULL;

-- COUNTRIES AND NUMBER OF ORDERS BETWEEN 2003 AND 2005 ( USA toping the list with 112 orders)
SELECT country, COUNT(c.country) AS count
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY country
ORDER BY count DESC;

-- JOINING THE EMPLOYEES TABLE WITH ITSELF TO SEE HEIRARCHY OF POSITIONS AS REQUESTED BY THE MANAGER 
SELECT e.employee_ID, 
       CONCAT(e.first_name, ' ' , e.last_name) AS Employee_Name,
       CONCAT(em.first_name, ' ' , em.last_name) AS Supervisor_Name
FROM employees e
JOIN employees em
ON e.Reports_To = em.Employee_ID;

-- JOINING THE EMPLOYEES TABLE WITH THE OFFICES TABLE TO SEE THE CITY, STATE AND ADDRESS WHERE EACH EMPLOYEE WORKS
SELECT e.employee_ID, 
	   e.First_Name, 
       e.Last_Name,
       e.job_title,
       o.city,
       o.first_address AS address,
       o.state,
       o.country
FROM employees e
JOIN offices o
ON e.office_code = o.officecode
ORDER BY Employee_ID;

-- CHECKING THE ORDERS TABLE TO SEE THE ORDERS  THAT HAVE BEEN SHIPPED
SELECT order_id, customer_id, shipped_date, status
FROM orders
WHERE status = 'shipped'
ORDER BY customer_id;

-- CHECKING TO SEE ORDERS THAT HAVE NOT BEEN SHIPPED (some on hold, in process, resolved or cancelled)
SELECT * 
FROM orders 
WHERE status <> 'shipped';

-- COUNTING THE NUMBER OF SHIPPED PRODUCTS (303 shipped products from 2003-2005)
SELECT COUNT(status) AS total_of_shipped
FROM orders 
WHERE status = 'shipped';

-- COUNTING THE NUMBER OF PRODUCTS STILL IN TRANSIT (6 products in 2005)
SELECT COUNT(status) AS Num_of_prod_in_transit
FROM orders 
WHERE status = 'in process';

-- COUNTING THE NUMBER OF ORDERS THAT HAVE NOT BEEN SHIPPED FROM 2003-2005 (some on hold, in process, resolved or cancelled) (23)
SELECT COUNT(status) AS num_of_products_not_shipped
FROM orders
WHERE status <> 'shipped';

-- LIST OF PRODUCTS ORDERED BY CUSTOMERS
SELECT od.product_id, 
	   od.order_id, 
       o.order_date, 
       od.quantity_ordered, 
       od.unit_price, 
       p.product_name, 
       p.product_line 
FROM orderdetails od
JOIN products p
USING (product_ID)
JOIN orders o
USING (order_id)
ORDER BY order_id;

-- LIST OF CUSTOMERS AND ORDERS THAT HAS BEEN SHIPPED, CHEQUE NUMBER, PAYMENT DATE AND AMOUNT
SELECT c.customer_ID, 
	   c.first_name, 
       c.last_name, 
       o.order_id, 
       o.order_date, 
       o.shipped_date, 
       o.status, 
       p.cheque_number, 
       p.payment_date, 
       p.amount
FROM orders o
JOIN customers c
USING (customer_ID)
JOIN payments p
USING (customer_ID)
ORDER BY customer_ID;

-- TOTAL LIST OF SALES FOR THE YEAR 2003
SELECT customer_id, 
	   payment_date,
       amount
FROM payments
WHERE payment_date <= '2003-12-31';

-- TOTAL AMOUNT OF SALES FOR THE YEAR 2003 (3,250,217.70)
SELECT SUM(amount) AS total_sales_for_2003
FROM payments 
WHERE payment_date <= '2003-12-31';

-- NUMBER OF SALES FOR THE YEAR 2003 (100 SALES)
SELECT COUNT(amount) AS number_of_payments 
FROM payments
WHERE payment_date <= '2003-12-31';

-- TOTAL LIST OF SALES FOR THE YEAR 2004
SELECT customer_id, 
	   payment_date, 
       amount
FROM payments 
WHERE payment_date BETWEEN '2004-01-01' AND '2004-12-31';

-- TOTAL AMOUNT OF SALES FOR THE YEAR 2004 (4,313,328.25)
SELECT SUM(amount) AS total_sales_for_2004
FROM payments 
WHERE payment_date BETWEEN '2004-01-01' AND '2004-12-31';

-- NUMBER OF SALES FOR THE YEAR 2004 (136 SALES)
SELECT COUNT(amount) AS number_of_sales
FROM payments 
WHERE payment_date BETWEEN '2004-01-01' AND '2004-12-31';

-- TOTAL LIST OF SALES FOR THE YEAR 2005
SELECT customer_id, 
       payment_date, 
       amount 
FROM payments 
WHERE payment_date BETWEEN '2005-01-01' AND '2005-12-31';

-- TOTAL AMOUNT OF SALES FOR THE YEAR 2005 (1,290,293.28)
SELECT SUM(amount) AS total_sales_for_2005
FROM payments 
WHERE payment_date BETWEEN '2005-01-01' AND '2005-12-31';

-- NUMBER OF SALES FOR THE YEAR 2005 (37 SALES)
SELECT COUNT(amount) AS number_of_payments
FROM payments
WHERE payment_date BETWEEN '2005-01-01' AND '2005-12-31'; 

-- CUSTOMERS AND SALES REP ASSIGNED TO THEM
SELECT c.customer_id,
	   c.first_name,
	   c.last_name, 
       c.company, 
       c.city, 
       c.country, 
       e.first_name AS sales_rep_name
FROM customers c 
JOIN employees e
ON c.sales_rep_id = e.employee_id;

-- LIST OF PRODUCTS ORDERED BY CUSTOMERS, PURCHASE PRICE, SALE PRICE AND PROFIT
SELECT p.product_id, 
	   p.product_name, 
       pl.product_line, 
       p.quantity_in_stock, 
       p.purchase_price, 
       p.sale_price, 
       (p.sale_price - p.purchase_price) AS estimated_profit
FROM products p
JOIN productlines pl
USING (product_line)
ORDER BY product_id;

-- CREATING A PRODUCTLINE_ID COLUMN AND MATCH IT WITH EACH PRODUCTLINE
ALTER TABLE productlines ADD COLUMN Product_Line_ID INT;
UPDATE productlines 
SET product_line_id = '1'
WHERE product_line = 'classic cars';
UPDATE productlines 
SET product_line_id = 2 
WHERE product_line = 'motorcycles';
UPDATE productlines 
SET product_line_id = 3
WHERE product_line = 'planes';
UPDATE productlines 
SET product_line_id = 4 
WHERE product_line = 'ships';
UPDATE productlines 
SET product_line_id = 5
WHERE product_line = 'trains';
UPDATE productlines 
SET product_line_id = 6 
WHERE product_line = 'trucks and buses';
UPDATE productlines 
SET product_line_id = 7 
WHERE product_line = 'vintage cars';
ALTER TABLE productlines MODIFY product_descripton VARCHAR (5000) AFTER product_line_id;

-- product with most orders
SELECT od.order_id,
	   p.product_line,
       p.product_name,
       od.quantity_ordered,
       o.order_date
FROM orderdetails od
JOIN products p
USING (product_id)
JOIN orders o
USING(order_id)
ORDER BY quantity_ordered DESC;

-- CREATING DUPLICATE TABLES FOR DASHBOARD

-- highest number of orders by country and customers
CREATE TABLE MOST_ORDERS_BY_CUST 
SELECT concat(c.first_name, ' ', c.last_name) AS customer_name,
       o.order_id,
       c.country,
       count(o.customer_id) AS orders
FROM orders o 
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id
ORDER BY count(o.customer_id) DESC;

-- total orders shipped from 2003 - 2005
CREATE TABLE TOTAL_SHIPPED_TABLE
SELECT COUNT(status) AS total_of_shipped
FROM orders 
WHERE status = 'shipped';

-- total sales from 2003 - 2005
CREATE TABLE TOTAL_SALES (Year VARCHAR (20), Amount VARCHAR (20));

-- products with most orders
CREATE TABLE MOST_ORDERED_PRODUCTLINE
SELECT p.product_line, 
	   COUNT(od.product_id) AS num_of_sales
FROM products p
JOIN orderdetails od
ON p.product_id = od.product_id
GROUP BY p.product_line
ORDER BY num_of_sales DESC;


-- total profit for card 
CREATE TABLE TOTAL_PROFIT_FOR_CARD 
SELECT SUM(estimated_profit)
FROM products_archive;

-- total sales by sum
CREATE TABLE TOTAL_SALES_BY_SUM
SELECT SUM(amount)
FROM total_sales