SELECT DATABASE();
USE db;

-- Creating Salespeople Table
CREATE TABLE SALESPEOPLE (
    SNUM INT PRIMARY KEY,
    SNAME VARCHAR(40),
    CITY VARCHAR(40),
    COMM DECIMAL(4,2)
);

-- Inserting Data into Salespeople table
INSERT INTO SALESPEOPLE (SNUM, SNAME, CITY, COMM) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15),
(1003, 'Axelrod', 'New York', 0.10);

-- Creating Customers Table
CREATE TABLE CUST (
    CNUM INT PRIMARY KEY,
    CNAME VARCHAR(40),
    CITY VARCHAR(40),
    RATING INT,
    SNUM INT,
    FOREIGN KEY (SNUM) REFERENCES SALESPEOPLE(SNUM) ON DELETE CASCADE
);

-- Inserting Data into Customers (Make sure CNUMs exist before inserting into Orders)
INSERT INTO CUST (CNUM, CNAME, CITY, RATING, SNUM) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004);

-- Create Orders Table
CREATE TABLE ORDERS (
    ONUM INT PRIMARY KEY,
    AMT DECIMAL(10,2),
    ODATE DATE,
    CNUM INT,
    SNUM INT,
    FOREIGN KEY (CNUM) REFERENCES CUST(CNUM) ON DELETE CASCADE,
    FOREIGN KEY (SNUM) REFERENCES SALESPEOPLE(SNUM) ON DELETE CASCADE
);


-- Insert Data into Orders (Ensure CNUM exists in CUST before inserting)
INSERT INTO ORDERS (ONUM, AMT, ODATE, CNUM, SNUM) VALUES
(3001, 18.69, '1994-10-03', 2001, 1007),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3002, 1900.10, '1994-10-03', 2007, 1004), 
(3005, 5160.45, '1994-10-03', 2003, 1002), 
(3006, 1098.16, '1994-10-04', 2003, 1004),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);


-- 1. Display snum, sname, city, and comm of all salespeople.
SELECT SNUM, SNAME, CITY, COMM FROM SALESPEOPLE;

-- 2. Display all snum without duplicates from orders.
SELECT DISTINCT SNUM FROM ORDERS;


-- 3. Display names and commissions of all salespeople in London.
SELECT SNAME, COMM FROM SALESPEOPLE WHERE CITY = 'London';

-- 4. All customers with a rating of 100.
SELECT * FROM CUST WHERE RATING = 100;


-- 5. Produce orderno, amount, and date from all rows in the order table.
SELECT ONUM, AMT, ODATE FROM ORDERS;

-- 6. All customers in San Jose with a rating greater than 200.
SELECT * FROM CUST WHERE CITY = 'San Jose' AND RATING > 200;

-- 7. All customers who are either located in San Jose or have a rating above 200.
SELECT * FROM CUST WHERE CITY = 'San Jose' OR RATING > 200;

-- 8. All orders greater than $1000.
SELECT * FROM ORDERS WHERE AMT > 1000;


-- 9. Names and cities of all salespeople in London with a commission above 0.10.
SELECT SNAME, CITY FROM SALESPEOPLE WHERE CITY = 'London' AND COMM > 0.10;

-- 10. All customers excluding those with rating <= 100 unless they are in Rome.
SELECT * FROM CUST WHERE RATING > 100 OR CITY = 'Rome';

-- 11. All salespeople either in Barcelona or London.
SELECT * FROM SALESPEOPLE WHERE CITY IN ('Barcelona', 'London');


-- 12. All salespeople with commission between 0.10 and 0.12 (excluding boundaries).
SELECT * FROM SALESPEOPLE WHERE COMM > 0.10 AND COMM < 0.12;

-- 13. All customers with NULL values in the city column.
SELECT * FROM CUST WHERE CITY IS NULL;

-- 14. All orders taken on Oct 3rd and Oct 4th, 1994.
SELECT * FROM ORDERS WHERE ODATE IN ('1994-10-03', '1994-10-04');

-- 15. All customers serviced by Peel or Motika.
SELECT * FROM CUST WHERE SNUM IN (SELECT SNUM FROM SALESPEOPLE WHERE SNAME IN ('Peel', 'Motika'));


-- 16. All customers whose names begin with A or B.
SELECT * FROM CUST WHERE CNAME LIKE 'A%' OR CNAME LIKE 'B%';

-- 17. All orders except those with 0 or NULL value in amt field.
SELECT * FROM ORDERS WHERE AMT IS NOT NULL AND AMT > 0;

-- 18. Count the number of salespeople currently listing orders.
SELECT COUNT(DISTINCT SNUM) FROM ORDERS;

-- 19. Largest order taken by each salesperson, datewise.
SELECT SNUM, ODATE, MAX(AMT) FROM ORDERS GROUP BY SNUM, ODATE;


-- 20. Largest order taken by each salesperson with order value more than $3000.
SELECT SNUM, MAX(AMT) FROM ORDERS WHERE AMT > 3000 GROUP BY SNUM;


-- 21. Which Day with the highest total amount ordered.
SELECT ODATE FROM ORDERS GROUP BY ODATE ORDER BY SUM(AMT) DESC LIMIT 1;


-- 22. Count all orders for Oct 3rd.
SELECT COUNT(*) FROM ORDERS WHERE ODATE = '1994-10-03';

-- 23. Count the number of different non-NULL city values in the customers table.
SELECT COUNT(DISTINCT CITY) FROM CUST WHERE CITY IS NOT NULL;

-- 24. Select each customer's smallest order.
SELECT CNUM, MIN(AMT) FROM ORDERS GROUP BY CNUM;

-- 25. First customer in alphabetical order whose name begins with G.
SELECT * FROM CUST WHERE CNAME LIKE 'G%' ORDER BY CNAME LIMIT 1;

-- 26. Get output like "For dd/mm/yy there are orders."
SELECT CONCAT('For ', ODATE, ' there are orders.') FROM ORDERS;

-- 27. Assume each salesperson has a 12% commission. Produce order no., salesperson no., and amount of commission.
SELECT ONUM, SNUM, AMT * 0.12 AS COMMISSION FROM ORDERS;


-- 28. 28.	Find highest rating in each city. Put the output in this form. For the city (city), the highest rating is : (rating).
SELECT CITY, MAX(RATING) FROM CUST GROUP BY CITY;


-- 29. 29.	Display the totals of orders for each day and place the results in descending order.
SELECT ODATE, SUM(AMT) FROM ORDERS GROUP BY ODATE ORDER BY SUM(AMT) DESC;

-- 30. All combinations of salespeople and customers who shared a city.
SELECT S.SNAME, C.CNAME, S.CITY FROM SALESPEOPLE S, CUST C WHERE S.CITY = C.CITY;


-- 31. Name of all customers matched with the salespeople serving them.
SELECT C.CNAME, S.SNAME FROM CUST C JOIN SALESPEOPLE S ON C.SNUM = S.SNUM;


-- 32. List each order number followed by the name of the customer who made the order.
SELECT O.ONUM, C.CNAME FROM ORDERS O JOIN CUST C ON O.CNUM = C.CNUM;

-- 33. Names of salesperson and customer for each order after the order number.
SELECT O.ONUM, S.SNAME, C.CNAME FROM ORDERS O JOIN SALESPEOPLE S ON O.SNUM = S.SNUM JOIN CUST C ON O.CNUM = C.CNUM;


-- 34. All customers serviced by salespeople with a commission above 12%.
SELECT * FROM CUST WHERE SNUM IN (SELECT SNUM FROM SALESPEOPLE WHERE COMM > 0.12);


-- 35. Calculate salesperson's commission on each order with a rating above 100.
SELECT O.ONUM, O.SNUM, O.AMT * S.COMM AS COMMISSION FROM ORDERS O JOIN SALESPEOPLE S ON O.SNUM = S.SNUM WHERE O.CNUM IN (SELECT CNUM FROM CUST WHERE RATING > 100);

-- 36. Find all pairs of customers having the same rating.
SELECT C1.CNAME, C2.CNAME, C1.RATING FROM CUST C1, CUST C2 WHERE C1.RATING = C2.RATING AND C1.CNUM < C2.CNUM;

-- 37. Find all pairs of customers having the same rating, each pair coming once only.
SELECT DISTINCT LEAST(C1.CNAME, C2.CNAME), GREATEST(C1.CNAME, C2.CNAME), C1.RATING FROM CUST C1, CUST C2 WHERE C1.RATING = C2.RATING AND C1.CNUM < C2.CNUM;

-- 38. Assign three salespeople to each customer.
SELECT C.CNUM, C.CNAME, S.SNUM, S.SNAME FROM CUST C CROSS JOIN (SELECT SNUM, SNAME FROM SALESPEOPLE LIMIT 3) S;

-- 39. All customers located in cities where salesperson Serres has customers.
SELECT * FROM CUST WHERE CITY IN (SELECT CITY FROM CUST WHERE SNUM = (SELECT SNUM FROM SALESPEOPLE WHERE SNAME = 'Serres'));


-- 40. Find all pairs of customers served by a single salesperson.
SELECT C1.CNAME, C2.CNAME FROM CUST C1 JOIN CUST C2 ON C1.SNUM = C2.SNUM AND C1.CNUM < C2.CNUM;


-- 41. Produce all pairs of salespeople living in the same city (excluding self-combinations).
SELECT S1.SNAME, S2.SNAME FROM SALESPEOPLE S1, SALESPEOPLE S2 WHERE S1.CITY = S2.CITY AND S1.SNUM < S2.SNUM;

-- 42. Produce all pairs of orders by a given customer, eliminating duplicates.
SELECT O1.ONUM, O2.ONUM FROM ORDERS O1, ORDERS O2 WHERE O1.CNUM = O2.CNUM AND O1.ONUM < O2.ONUM;

-- 43. Names and cities of all customers with the same rating as Hoffman.
SELECT CNAME, CITY FROM CUST WHERE RATING = (SELECT RATING FROM CUST WHERE CNAME = 'Hoffman');

-- 44. Extract all the orders of Motika.
SELECT * FROM ORDERS WHERE SNUM = (SELECT SNUM FROM SALESPEOPLE WHERE SNAME = 'Motika');

-- 45. All orders credited to the same salesperson who services Hoffman.
SELECT * FROM ORDERS WHERE SNUM = (SELECT SNUM FROM CUST WHERE CNAME = 'Hoffman');

-- 46. All orders greater than the average order amount for Oct 4.
SELECT * FROM ORDERS WHERE AMT > (SELECT AVG(AMT) FROM ORDERS WHERE ODATE = '1994-10-04');

-- 47. Find the average commission of salespeople in London.
SELECT AVG(COMM) FROM SALESPEOPLE WHERE CITY = 'London';

-- 48. Find all orders attributed to salespeople servicing customers in London.
SELECT * FROM ORDERS WHERE SNUM IN (SELECT SNUM FROM CUST WHERE CITY = 'London');

-- 49. Extract commissions of all salespeople servicing customers in London.
SELECT SNUM, COMM FROM SALESPEOPLE WHERE SNUM IN (SELECT SNUM FROM CUST WHERE CITY = 'London');

-- 50. Find all customers whose CNUM is 1000 above Serres' SNUM.
SELECT * FROM CUST WHERE CNUM = (SELECT SNUM FROM SALESPEOPLE WHERE SNAME = 'Serres') + 1000;

-- 51. Count the customers with a rating above San Jose’s average rating.
SELECT COUNT(*) FROM CUST WHERE RATING > (SELECT AVG(RATING) FROM CUST WHERE CITY = 'San Jose');

-- 52. Obtain all orders for the customer named 'Cisnerous' (assuming CNUM is unknown).
SELECT * FROM ORDERS WHERE CNUM = (SELECT CNUM FROM CUST WHERE CNAME = 'Cisnerous');

-- 53. Names and ratings of all customers who have above-average orders.
SELECT C.CNAME, C.RATING FROM CUST C WHERE C.CNUM IN (SELECT O.CNUM FROM ORDERS O GROUP BY O.CNUM HAVING AVG(O.AMT) > (SELECT AVG(AMT) FROM ORDERS));

-- 54. Find total orders per salesperson where total is greater than the largest order.
SELECT SNUM, SUM(AMT) FROM ORDERS GROUP BY SNUM HAVING SUM(AMT) > (SELECT MAX(AMT) FROM ORDERS);

-- 55. Find all customers with an order on Oct 3rd.
SELECT * FROM CUST WHERE CNUM IN (SELECT CNUM FROM ORDERS WHERE ODATE = '1994-10-03');

-- 56. Names and numbers of salespeople who have more than one customer.
SELECT SNUM, SNAME FROM SALESPEOPLE WHERE SNUM IN (SELECT SNUM FROM CUST GROUP BY SNUM HAVING COUNT(*) > 1);


-- 57. Check if the correct salesperson was credited with each sale.
SELECT * FROM ORDERS O JOIN CUST C ON O.CNUM = C.CNUM WHERE O.SNUM <> C.SNUM;


-- 58. Find all orders above the average amount for their respective customers.
SELECT * FROM ORDERS O1 WHERE AMT > (SELECT AVG(O2.AMT) FROM ORDERS O2 WHERE O2.CNUM = O1.CNUM GROUP BY O2.CNUM);

-- 59. Find sums of amounts grouped by date, eliminating dates where the sum is not at least 2000 above the max order.
SELECT ODATE, SUM(AMT) FROM ORDERS GROUP BY ODATE HAVING SUM(AMT) > (SELECT MAX(AMT) FROM ORDERS) + 2000;

-- 60. Names and numbers of customers with ratings equal to the max rating in their city.
SELECT CNAME, CNUM FROM CUST WHERE (CITY, RATING) IN (SELECT CITY, MAX(RATING) FROM CUST GROUP BY CITY);

-- 61. Salespeople who have customers in their cities but don’t serve them (Join and Correlated Subquery).
SELECT S.SNUM, S.SNAME FROM SALESPEOPLE S WHERE EXISTS (SELECT 1 FROM CUST C WHERE C.CITY = S.CITY AND C.SNUM <> S.SNUM);

-- 62. Extract CNUM, CNAME, and CITY from customers if one or more customers exist in San Jose.
SELECT CNUM, CNAME, CITY FROM CUST WHERE EXISTS (SELECT 1 FROM CUST WHERE CITY = 'San Jose');

-- 63. Find salespeople numbers who have multiple customers.
SELECT SNUM FROM CUST GROUP BY SNUM HAVING COUNT(*) > 1;

-- 64. Find salespeople number, name, and city who have multiple customers.
SELECT SNUM, SNAME, CITY FROM SALESPEOPLE WHERE SNUM IN (SELECT SNUM FROM CUST GROUP BY SNUM HAVING COUNT(*) > 1);

-- 65. Find salespeople who serve only one customer.
SELECT SNUM FROM SALESPEOPLE WHERE SNUM IN (SELECT SNUM FROM CUST GROUP BY SNUM HAVING COUNT(*) = 1);

-- 66. Extract salespeople with more than one current order.
SELECT SNUM FROM ORDERS GROUP BY SNUM HAVING COUNT(*) > 1;

-- 67. Salespeople with customers having a rating of 300 (using EXISTS).
SELECT * FROM SALESPEOPLE WHERE EXISTS (SELECT 1 FROM CUST WHERE CUST.RATING = 300 AND SALESPEOPLE.SNUM = CUST.SNUM);

-- 68. Salespeople with customers having a rating of 300 (using Join).
SELECT DISTINCT S.* FROM SALESPEOPLE S JOIN CUST C ON S.SNUM = C.SNUM WHERE C.RATING = 300;


-- 69. Salespeople with customers in their cities but not assigned to them (using EXISTS).
SELECT * FROM SALESPEOPLE WHERE EXISTS (SELECT 1 FROM CUST WHERE CUST.CITY = SALESPEOPLE.CITY AND CUST.SNUM <> SALESPEOPLE.SNUM);

-- 70. Customers assigned to salespeople who have at least one other customer with orders.
SELECT CNUM, CNAME FROM CUST WHERE SNUM IN (SELECT SNUM FROM CUST WHERE CNUM IN (SELECT CNUM FROM ORDERS) GROUP BY SNUM HAVING COUNT(*) > 1);


-- 71. Salespeople with customers in their cities (using ANY and IN).
SELECT * FROM SALESPEOPLE WHERE CITY = ANY (SELECT CITY FROM CUST);

-- 72. Salespeople for whom there are customers following them in alphabetical order (Using ANY and EXISTS).
SELECT * FROM SALESPEOPLE WHERE EXISTS (SELECT 1 FROM CUST WHERE CUST.CNAME > SALESPEOPLE.SNAME);

-- 73. Customers with a greater rating than any customer in Rome.
SELECT * FROM CUST WHERE RATING > ANY (SELECT RATING FROM CUST WHERE CITY = 'Rome');

-- 74. Orders greater than at least one order from Oct 6.
SELECT * FROM ORDERS WHERE AMT > ANY (SELECT AMT FROM ORDERS WHERE ODATE = '1994-10-06');

-- 75. Orders with amounts smaller than any amount for a customer in San Jose (Using ANY).
SELECT * FROM ORDERS WHERE AMT < ANY (SELECT AMT FROM ORDERS WHERE CNUM IN (SELECT CNUM FROM CUST WHERE CITY = 'San Jose'));

-- 76. Customers whose ratings are higher than every customer in Paris (Using ALL and NOT EXISTS).
SELECT * FROM CUST WHERE RATING > ALL (SELECT RATING FROM CUST WHERE CITY = 'Paris');

-- 77. Customers whose ratings are equal to or greater than ANY of Serres'.
SELECT * FROM CUST WHERE RATING >= ANY (SELECT RATING FROM CUST WHERE SNUM = (SELECT SNUM FROM SALESPEOPLE WHERE SNAME = 'Serres'));

-- 78. Salespeople who have no customers in their city (Using ANY and ALL).
SELECT * FROM SALESPEOPLE WHERE CITY <> ALL (SELECT CITY FROM CUST);


-- 79. Orders greater than any for customers in London.
SELECT * FROM ORDERS WHERE AMT > ANY (SELECT AMT FROM ORDERS WHERE CNUM IN (SELECT CNUM FROM CUST WHERE CITY = 'London'));

-- 80. Salespeople and customers located in London.
SELECT SNAME AS NAME, CITY, 'Salesperson' AS TYPE 
FROM SALESPEOPLE 
WHERE CITY = 'London'
UNION 
SELECT CNAME AS NAME, CITY, 'Customer' AS TYPE 
FROM CUST 
WHERE CITY = 'London';

-- 81. For every salesperson, dates on which highest and lowest orders were brought.
SELECT SNUM, 
       MAX(ODATE) AS HIGHEST_ORDER_DATE, 
       MIN(ODATE) AS LOWEST_ORDER_DATE 
FROM ORDERS 
GROUP BY SNUM;

-- 82. List all of the salespeople and indicate those who don't have customers in their cities as well as those who do have.
SELECT S.SNUM, S.SNAME, S.CITY, 
       CASE 
           WHEN EXISTS (SELECT 1 FROM CUST C WHERE C.CITY = S.CITY AND C.SNUM = S.SNUM) 
           THEN 'Has Customers' 
           ELSE 'No Customers' 
       END AS CUSTOMER_STATUS
FROM SALESPEOPLE S;

-- 83. Append strings to the selected fields, indicating whether or not a given salesperson was matched to a customer in his city.
SELECT S.SNUM, S.SNAME, S.CITY, 
       CASE 
           WHEN EXISTS (SELECT 1 FROM CUST C WHERE C.CITY = S.CITY) 
           THEN CONCAT(S.SNAME, ' - Matched to Customer') 
           ELSE CONCAT(S.SNAME, ' - No Match') 
       END AS MATCH_STATUS
FROM SALESPEOPLE S;

-- 84. Create a UNION of two queries that shows the names, cities, and ratings of all customers.  
-- Those with a rating of 200 or greater will also have 'High Rating', while others will have 'Low Rating'.
SELECT CNAME, CITY, RATING, 'High Rating' AS STATUS 
FROM CUST WHERE RATING >= 200
UNION
SELECT CNAME, CITY, RATING, 'Low Rating' AS STATUS 
FROM CUST WHERE RATING < 200;

-- 85. Produce the name and number of each salesperson and each customer with more than one current order, in alphabetical order.
SELECT SNUM, SNAME FROM SALESPEOPLE 
WHERE SNUM IN (SELECT SNUM FROM ORDERS GROUP BY SNUM HAVING COUNT(*) > 1)
UNION 
SELECT CNUM, CNAME FROM CUST 
WHERE CNUM IN (SELECT CNUM FROM ORDERS GROUP BY CNUM HAVING COUNT(*) > 1)
ORDER BY SNAME;

-- 86. UNION of three queries:  
SELECT SNUM FROM SALESPEOPLE WHERE CITY = 'San Jose'
UNION 
SELECT CNUM FROM CUST WHERE CITY = 'San Jose'
UNION ALL
SELECT ONUM FROM ORDERS WHERE ODATE = '1994-10-03';

-- 87. Produce all the salespeople in London who had at least one customer there.
SELECT * FROM SALESPEOPLE 
WHERE CITY = 'London' AND SNUM IN (SELECT SNUM FROM CUST WHERE CITY = 'London');

-- 88. Produce all the salespeople in London who did not have customers there.
SELECT * FROM SALESPEOPLE 
WHERE CITY = 'London' AND SNUM NOT IN (SELECT SNUM FROM CUST WHERE CITY = 'London');


-- 89. Match salespeople to customers, including salespeople who have no assigned customers.
SELECT S.SNUM, S.SNAME, C.CNUM, C.CNAME
FROM SALESPEOPLE S 
LEFT JOIN CUST C ON S.SNUM = C.SNUM;
