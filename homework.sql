--การ Query ข้อมูลจากหลายตาราง (Join)
-- 1.   จงแสดงข้อมูลรหัสใบสั่งซื้อ ชื่อบริษัทลูกค้า ชื่อและนามสกุลพนักงาน(ในคอลัมน์เดียวกัน) วันที่สั่งซื้อ ชื่อบริษัทขนส่งของ เมืองและประเทศที่ส่งของไป รวมถึงยอดเงินที่ต้องรับจากลูกค้าด้วย  
SELECT  o.OrderID,c.CompanyName AS Customer, e.FirstName + ' ' + e.LastName AS Employee, o.OrderDate, s.CompanyName AS Shipper, o.ShipCity,o.ShipCountry,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalAmount
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
              JOIN Employees e ON o.EmployeeID = e.EmployeeID
              JOIN Shippers s ON o.ShipVia = s.ShipperID
              JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName, e.FirstName, e.LastName, o.OrderDate, s.CompanyName, o.ShipCity, o.ShipCountry;

-- 2.   จงแสดง ข้อมูล ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เมือง ประเทศ จำนวนใบสั่งซื้อที่เกี่ยวข้องและ ยอดการสั่งซื้อทั้งหมดเลือกมาเฉพาะเดือน มกราคมถึง มีนาคม  1997
SELECT  c.CompanyName, c.ContactName, c.City, c.Country,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
              JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-03-31'
GROUP BY c.CompanyName, c.ContactName, c.City, c.Country;

-- 3.   จงแสดงชื่อเต็มของพนักงาน ตำแหน่ง เบอร์โทรศัพท์ จำนวนใบสั่งซื้อ รวมถึงยอดการสั่งซื้อทั้งหมดในเดือนพฤศจิกายน ธันวาคม 2539  โดยที่ใบสั่งซื้อนั้นถูกส่งไปประเทศ USA, Canada หรือ Mexico
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName, e.Title, e.HomePhone,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalAmount
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
                 JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '1996-11-01' AND '1996-12-31'
  AND o.ShipCountry IN ('USA', 'Canada', 'Mexico')
GROUP BY e.FirstName, e.LastName, e.Title, e.HomePhone;

-- 4.   จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย  และจำนวนทั้งหมดที่ขายได้ในเดือน มิถุนายน 2540
SELECT p.ProductID, p.ProductName, p.UnitPrice,
     SUM(od.Quantity) AS TotalQuantity
FROM Orders o   JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1997-06-01' AND '1997-06-30'
GROUP BY p.ProductID, p.ProductName, p.UnitPrice;

-- 5.   จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย และยอดเงินทั้งหมดที่ขายได้ ในเดือน มกราคม 2540 แสดงเป็นทศนิยม 2 ตำแหน่ง
SELECT  p.ProductID, p.ProductName,p.UnitPrice,
    CAST(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS DECIMAL(10,2)) AS TotalAmount
FROM Orders o   JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-01-31'
GROUP BY p.ProductID, p.ProductName, p.UnitPrice;

-- 6.   จงแสดงชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร เบอร์ Fax รหัส ชื่อสินค้า ราคา จำนวนรวมที่จำหน่ายได้ในปี 1996
SELECT sp.CompanyName, sp.ContactName, sp.Phone, sp.Fax, p.ProductID, p.ProductName, p.UnitPrice,
    SUM(od.Quantity) AS TotalQuantity
FROM Orders o   JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Suppliers sp ON p.SupplierID = sp.SupplierID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY sp.CompanyName, sp.ContactName, sp.Phone, sp.Fax, p.ProductID, p.ProductName, p.UnitPrice;

-- 7.   จงแสดงรหัสสินค้า ชื่อสินค้า ราคาต่อหน่วย  และจำนวนทั้งหมดที่ขายได้เฉพาะของสินค้าที่เป็นประเภท Seafood และส่งไปประเทศ USA ในปี 1997
SELECT  p.ProductID, p.ProductName, p.UnitPrice,
    SUM(od.Quantity) AS TotalQuantity
FROM Orders o   JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE YEAR(o.OrderDate) = 1997
  AND o.ShipCountry = 'USA'
  AND cat.CategoryName = 'Seafood'
GROUP BY p.ProductID, p.ProductName, p.UnitPrice;

-- 8.   จงแสดงชื่อเต็มของพนักงานที่มีตำแหน่ง Sale Representative อายุงานเป็นปี และจำนวนใบสั่งซื้อทั้งหมดที่รับผิดชอบในปี 1998
SELECT  e.FirstName + ' ' + e.LastName AS Employee, e.Title,
    DATEDIFF(year, e.HireDate, GETDATE()) AS YearsWorked,
    COUNT(DISTINCT o.OrderID) AS TotalOrders
FROM Employees e  LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID AND YEAR(o.OrderDate) = 1998
WHERE e.Title = 'Sales Representative'
GROUP BY e.FirstName, e.LastName, e.Title, e.HireDate;

-- 9.   แสดงชื่อเต็มพนักงาน ตำแหน่งงาน ของพนักงานที่ขายสินค้าให้บริษัท Frankenversand ในปี  1996
SELECT DISTINCT  e.FirstName + ' ' + e.LastName AS Employee, e.Title
FROM Orders o   JOIN Employees e ON o.EmployeeID = e.EmployeeID
                JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CompanyName = 'Frankenversand'
  AND YEAR(o.OrderDate) = 1996;

-- 10.  จงแสดงชื่อสกุลพนักงานในคอลัมน์เดียวกัน ยอดขายสินค้าประเภท Beverage ที่แต่ละคนขายได้ ในปี 1996
SELECT e.LastName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Orders o   JOIN Employees e ON o.EmployeeID = e.EmployeeID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE YEAR(o.OrderDate) = 1996
  AND cat.CategoryName = 'Beverages'
GROUP BY e.LastName;

-- 11.  จงแสดงชื่อประเภทสินค้า รหัสสินค้า ชื่อสินค้า ยอดเงินที่ขายได้(หักส่วนลดด้วย) ในเดือนมกราคม - มีนาคม 2540 โดย มีพนักงานผู้ขายคือ Nancy
SELECT cat.CategoryName, p.ProductID, p.ProductName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalAmount
FROM Orders o   JOIN Employees e ON o.EmployeeID = e.EmployeeID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE e.FirstName = 'Nancy'
  AND o.OrderDate BETWEEN '1997-01-01' AND '1997-03-31'
GROUP BY cat.CategoryName, p.ProductID, p.ProductName;

-- 12.  จงแสดงชื่อบริษัทลูกค้าที่ซื้อสินค้าประเภท Seafood ในปี 1997
SELECT DISTINCT c.CompanyName
FROM Orders o   JOIN Customers c ON o.CustomerID = c.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE YEAR(o.OrderDate) = 1997
  AND cat.CategoryName = 'Seafood';

-- 13.  จงแสดงชื่อบริษัทขนส่งสินค้า ที่ส่งสินค้าให้ ลูกค้าที่มีที่ตั้ง อยู่ที่ถนน Johnstown Road แสดงวันที่ส่งสินค้าด้วย (รูปแบบ 106)
SELECT DISTINCT  s.CompanyName, o.ShippedDate
FROM Orders o   JOIN Shippers s ON o.ShipVia = s.ShipperID
                JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Address LIKE '%Johnstown Road%';


-- 14.  จงแสดงรหัสประเภทสินค้า ชื่อประเภทสินค้า จำนวนสินค้าในประเภทนั้น และยอดรวมที่ขายได้ทั้งหมด แสดงเป็นทศนิยม 4 ตำแหน่ง หักส่วนลด
SELECT cat.CategoryID, cat.CategoryName,
    COUNT(p.ProductID) AS TotalProducts,
    CAST(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS DECIMAL(12,4)) AS TotalSales
FROM [Order Details] od JOIN Products p ON od.ProductID = p.ProductID
                        JOIN Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName;


-- 15.  จงแสดงชื่อบริษัทลูกค้า ที่อยู่ในเมือง London , Cowes ที่สั่งซื้อสินค้าประเภท Seafood จากบริษัทตัวแทนจำหน่ายที่อยู่ในประเทศญี่ปุ่นรวมมูลค่าออกมาเป็นเงินด้วย
SELECT 
    c.CompanyName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalAmount
FROM Orders o   JOIN Customers c ON o.CustomerID = c.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Suppliers sp ON p.SupplierID = sp.SupplierID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE c.City IN ('London','Cowes')
  AND cat.CategoryName = 'Seafood'
  AND sp.Country = 'Japan'
GROUP BY c.CompanyName;

-- 16.  แสดงรหัสบริษัทขนส่ง ชื่อบริษัทขนส่ง จำนวนorders ที่ส่ง ค่าขนส่งทั้งหมด  เฉพาะที่ส่งไปประเทศ USA
SELECT  s.ShipperID, s.CompanyName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.Freight) AS TotalFreight
FROM Orders o   JOIN Shippers s ON o.ShipVia = s.ShipperID
WHERE o.ShipCountry = 'USA'
GROUP BY s.ShipperID, s.CompanyName;

-- 17.  จงแสดงเต็มชื่อพนักงาน ที่มีอายุมากกว่า 60ปี จงแสดง ชื่อบริษัทลูกค้า,ชื่อผู้ติดต่อ,เบอร์โทร,Fax,ยอดรวมของสินค้าประเภท Condiment ที่ลูกค้าแต่ละรายซื้อ แสดงเป็นทศนิยม4ตำแหน่ง,และแสดงเฉพาะลูกค้าที่มีเบอร์แฟกซ์
SELECT e.FirstName + ' ' + e.LastName AS Employee, c.CompanyName, c.ContactName, c.Phone, c.Fax,
    CAST(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS DECIMAL(12,4)) AS TotalCondimentSales
FROM Orders o   JOIN Employees e ON o.EmployeeID = e.EmployeeID
                JOIN Customers c ON o.CustomerID = c.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
                JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE DATEDIFF(year, e.BirthDate, GETDATE()) > 60
  AND c.Fax IS NOT NULL
  AND cat.CategoryName = 'Condiments'
GROUP BY e.FirstName, e.LastName, c.CompanyName, c.ContactName, c.Phone, c.Fax;

-- 18.  จงแสดงข้อมูลว่า วันที่  3 มิถุนายน 2541 พนักงานแต่ละคน ขายสินค้า ได้เป็นยอดเงินเท่าใด พร้อมทั้งแสดงชื่อคนที่ไม่ได้ขายของด้วย
SELECT e.FirstName + ' ' + e.LastName AS Employee,
    ISNULL(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),0) AS TotalSales
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID AND o.OrderDate = '1998-06-03'
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.FirstName, e.LastName;

-- 19.  จงแสดงรหัสรายการสั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า เบอร์โทร วันที่ลูกค้าต้องการสินค้า เฉพาะรายการที่มีพนักงานชื่อมากาเร็ตเป็นคนรับผิดชอบพร้อมทั้งแสดงยอดเงินรวมที่ลูกค้าต้องชำระด้วย (ทศนิยม 2 ตำแหน่ง)
SELECT o.OrderID, e.FirstName + ' ' + e.LastName AS Employee, c.CompanyName, c.Phone, o.RequiredDate,
    CAST(SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS DECIMAL(10,2)) AS TotalAmount
FROM Orders o   JOIN Employees e ON o.EmployeeID = e.EmployeeID
                JOIN Customers c ON o.CustomerID = c.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE e.FirstName = 'Margaret'
  AND YEAR(o.OrderDate) = 1996
GROUP BY o.OrderID, e.FirstName, e.LastName, c.CompanyName, c.Phone, o.RequiredDate;

-- 20.  จงแสดงชื่อเต็มพนักงาน อายุงานเป็นปี และเป็นเดือน ยอดขายรวมที่ขายได้ เลือกมาเฉพาะลูกค้าที่อยู่ใน USA, Canada, Mexico และอยู่ในไตรมาศแรกของปี 2541
SELECT  e.FirstName + ' ' + e.LastName AS Employee,
    DATEDIFF(year, e.HireDate, GETDATE()) AS YearsWorked,
    DATEDIFF(month, e.HireDate, GETDATE()) AS MonthsWorked,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
                 JOIN [Order Details] od ON o.OrderID = od.OrderID
                 JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 1998
  AND MONTH(o.OrderDate) BETWEEN 1 AND 3
  AND c.Country IN ('USA','Canada','Mexico')
GROUP BY e.FirstName, e.LastName, e.HireDate;
