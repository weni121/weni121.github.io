--1--
SELECT Title 
FROM Employees
WHERE FirstName = 'Nancy';
--2-- 
SELECT * 
FROM Employees
WHERE Title = (SELECT Title FROM Employees WHERE FirstName = 'Nancy');
--3--
SELECT FirstName, LastName 
FROM Employees
WHERE BirthDate = (SELECT MIN(BirthDate) FROM Employees);
--4--
SELECT ProductName 
FROM Products
WHERE UnitPrice > (SELECT UnitPrice FROM Products WHERE ProductName = 'Ikura');
--5--
SELECT CompanyName 
FROM Customers
WHERE City = (SELECT City FROM Customers WHERE CompanyName = 'Around the Horn');
--6--
SELECT FirstName, LastName 
FROM Employees
WHERE HireDate = (SELECT MAX(HireDate) FROM Employees);
--7--
SELECT * 
FROM Orders
WHERE ShipCountry NOT IN (SELECT DISTINCT Country FROM Suppliers);
--8--
SELECT 
  ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum,
  ProductName, 
  UnitPrice
FROM Products 
WHERE UnitPrice < 50;
--9--
SELECT * FROM Shippers;
--10--
INSERT INTO Shippers (CompanyName, Phone)
VALUES ('บริษัทขนเยอะจำกัด','081-12345678');
--11--
INSERT INTO Shippers (CompanyName)
VALUES ('บริษัทขนมหาศาลจำกัด');
--12--
SELECT * FROM Customers;
--13--
INSERT INTO Customers (CustomerID, CompanyName)
VALUES ('A0001','บริษัทซื้อเยอะจำกัด');
-- เพิ่มพนักงานใหม่ (ข้อมูลเท่าที่มี)
INSERT INTO Employees (FirstName, LastName)
VALUES ('วุ้นเส้น','เขมรสกุล');

--จงเพิ่มสินค้า ปลาแดกบอง ราคา 1.5$ จำนวน 12
INSERT INTO Products (ProductName, UnitPrice, UnitsInStock)
VALUES ('ปลาแดกบอง', 1.50, 12);
--คำสั่ง Updete ปรังปรุงข้อมูล
Update Shippers
set Phone = '085-999-9599'
WHERE ShipperID = 6

SELECT * FROM Shippers


--ปรับปรุงจำนวนสินค้าคงเหลือสินค้ารหัส 1 เิ่มจำนวนเข้าไป 100 ชิ้น
Update Products
set UnitsInStock = UnitsInStock+100
WHERE ProductID = 1

--ปรังปรุง เมืองและประเทศลูกค้า รหัส A0001 ให้เป็น อุดรธานี, Thailand
update Customer
set city = 'อุดรธานี', Country = 'Thailand'
WHERE CustomerID ='A0001'


--14--
Delete FROM Products
WHERE ProductID = 78
--ลบบริษัทขนส่งเบอร์6
Delete FROM Shippers
WHERE ShipperID = 4


SELECT * FROM Employees

--ต้องการข้อมูล รหัสและชื่อพนักงาน และรหัสและชื่อพนักงาน
SELECT emp.EmployeeID, emp.FirstName ชื่อพนักงาน
        boss.EmployeeID, boss.FirstName ชื่อหัวหน้า
FROM Employees emp JOIN Employees boss
ON emp.ReportsTo = boss.EmployeeID