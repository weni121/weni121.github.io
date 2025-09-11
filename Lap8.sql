--1--
SELECT title FROM Employees WHERE FirstName = ' nancy '
--2--
SELECT * FROM Employees
WHERE title + (SELECT title FROM Employees WHERE FirstName = 'nancy')
--3--
SELECT FirstName, LastName FROM Employees
WHERE BirthDate = (SELECT min(BirthDate) FROM Employees)
--4--
SELECT ProductName FROM Products
WHERE UnitPrice > (SELECT UnitPrice FROM Products WHERE ProductName = 'Ikura')
--5--
SELECT CompanyName FROM Customer
WHERE city =(SELECT city FROM Customers WHERE CompanyName =  'Aroound the Horn')
--6--
SELECT FirstName, LastName FROM Employees
WHERE HireData = (SELECT max(HireData)FROM Employees)
--7--
SELECT * FROM Orders
WHERE shipcountry not in (SELECT distinct county FROM Suppliers)
--8--
SELECT  ROW_NUMBER() ORDER (ORDER BY UnitPrice DESC) AS RowNum,
ProductName, Untiprice GROUP 
FROM Products 
WHERE UnitPrice <50


