--From the HumanResources.Employee table write a query in SQL to retrieve all rows and columns from the employee table in the Adventureworks database.
--Sort the result set in ascending order on jobtitle.

SELECT * FROM HumanResources.Employee
ORDER BY JobTitle;

--From the Person.Person table write a query in SQL to retrieve all rows and columns from the employee table using table aliasing in the Adventureworks database. 
--Sort the output in ascending order on lastname.

SELECT P.* FROM Person.Person AS P
ORDER BY lastname;

--write a query in SQL to return all rows and a subset of the columns (FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. 
--The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.
SELECT FirstName, LastName, businessentityid AS Employee_id FROM Person.Person
ORDER BY LastName;

-- From the production.Product table write a query in SQL to return only the rows for product that have a sellstartdate that is not NULL and a productline of 'T'. 
--Return productid, productnumber, and name. Arranged the output in ascending order on name

SELECT productid, productnumber, name
FROM production.Product
WHERE SellStartDate IS NOT NULL AND productline = 'T'
ORDER BY name;

--From the following table write a query in SQL to return all rows from the salesorderheader table in Adventureworks database. 
--Calculate the percentage of tax on the subtotal have decided. Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. 
--Arranged the result set in ascending order on subtotal.

SELECT salesorderid, customerid, orderdate, subtotal, (TaxAmt * 100)/subtotal AS tax_percent 
FROM Sales.SalesOrderHeader
ORDER BY Subtotal desc;

--From the HumanResources.Employee table write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database. 
--Return jobtitle column and arranged the resultset in ascending order. 
 SELECT DISTINCT jobtitle FROM HumanResources.Employee
 ORDER BY JobTitle;

 -- From the  Person.BusinessEntityAddress table write a query in SQL to retrieve the number of employees for each City. 
 --Return city and number of employees. Sort the result in ascending order on city.

 SELECT a.city, COUNT(*) AS num_of_emp FROM  Person.BusinessEntityAddress AS bea
 INNER JOIN Person.Address AS a  
 ON bea.AddressID = a.AddressID  
 GROUP BY a.city
 ORDER BY a.city;

 --From the Sales.SalesOrderHeader table write a query in SQL to retrieve the total sales for each year. Return the year part of order date and total due amount.
 --Sort the result in ascending order on year part of order date.
SELECT SUM(totaldue) AS total_amount, YEAR(orderdate) AS year
FROM Sales.SalesOrderHeader
GROUP BY YEAR(orderdate)
ORDER BY YEAR(orderdate);


--From the Person.ContactType table write a query in SQL to find the contacts who are designated as a manager in various departments. 
--Returns ContactTypeID, name. Sort the result set in descending order.
SELECT contacttypeid, name 
FROM Person.ContactType
WHERE name LIKE '%Manager%'
ORDER BY name DESC;

--From the Person.BusinessEntityContact, Person.ContactType, and Person.Person tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'.
--Return BusinessEntityID, LastName, and FirstName columns. 
--Sort the result set in ascending order of LastName, and FirstName.

SELECT Per.BusinessEntityID, bec.LastName, bec.FirstName
FROM Person.BusinessEntityContact AS Per
INNER JOIN Person.Person AS bec
ON bec.BusinessEntityID = Per.PersonID
INNER JOIN Person.ContactType AS ct
ON ct.ContactTypeID = Per.ContactTypeID
WHERE ct.Name LIKE 'Purchasing Manager'
ORDER BY bec.LastName, bec.FirstName;

--From the Person.BusinessEntityContact and Person.ContactType tables write a query in SQL to count the number of contacts for combination of each type and name. 
--Filter the output for those who have 100 or more contacts. Return ContactTypeID and ContactTypeName and BusinessEntityContact. 
--Sort the result set in descending order on number of contacts.

SELECT pc.ContactTypeID, pc.Name AS CTypeName, COUNT(*) AS NOcontacts
FROM Person.BusinessEntityContact AS pbe
INNER JOIN Person.ContactType AS pc
ON pc.ContactTypeID = pbe.ContactTypeID
GROUP BY pc.ContactTypeID, pc.Name
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;