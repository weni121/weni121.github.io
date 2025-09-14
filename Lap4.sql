-- 1.   จงแสดงให้เห็นว่าพนักงานแต่ละคนขายสินค้าประเภท Beverage ได้เป็นจำนวนเท่าใด และเป็นจำนวนกี่ชิ้น เฉพาะครึ่งปีแรกของ 2540(ทศนิยม 4 ตำแหน่ง)
SELECT e.EmployeeID,e.FirstName + ' ' + e.LastName AS EmployeeName,CAST(ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 4) AS DECIMAL(18,4)) AS TotalAmount,CAST(ROUND(SUM(od.Quantity),4) AS DECIMAL(18,4)) AS TotalQuantity
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
AND o.OrderDate >= '1997-01-01' AND o.OrderDate < '1997-07-01'
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID;
-- 2.   จงแสดงชื่อบริษัทตัวแทนจำหน่าย  เบอร์โทร เบอร์แฟกซ์ ชื่อผู้ติดต่อ จำนวนชนิดสินค้าประเภท Beverage ที่จำหน่าย โดยแสดงจำนวนสินค้า จากมากไปน้อย 3 อันดับแรก
SELECT TOP 3 
    s.CompanyName, s.Phone, s.Fax, s.ContactName,
    COUNT(p.ProductID) AS BeverageCount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
GROUP BY s.CompanyName, s.Phone, s.Fax, s.ContactName
ORDER BY COUNT(p.ProductID) DESC;
-- 3.   จงแสดงข้อมูลชื่อลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ ของลูกค้าที่ซื้อของในเดือน สิงหาคม 2539 ยอดรวมของการซื้อโดยแสดงเฉพาะ ลูกค้าที่ไม่มีเบอร์แฟกซ์
SELECT c.CompanyName, c.ContactName, c.Phone, SUM(od.UnitPrice*od.Quantity) AS TotalPurchase
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = 8 AND YEAR(o.OrderDate) = 1996
  AND c.Fax IS NULL
GROUP BY c.CompanyName, c.ContactName, c.Phone;
-- 4.   แสดงรหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ทั้งหมดในปี 2541 ยอดเงินรวมที่ขายได้ทั้งหมดโดยเรียงลำดับตาม จำนวนที่ขายได้เรียงจากน้อยไปมาก พรอ้มทั้งใส่ลำดับที่ ให้กับรายการแต่ละรายการด้วย
SELECT ROW_NUMBER() OVER(ORDER BY SUM(od.Quantity) ASC) AS Rank,
       p.ProductID, p.ProductName,
       SUM(od.Quantity) AS TotalQuantity,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantity ASC;
-- 5.   จงแสดงข้อมูลของสินค้าที่ขายในเดือนมกราคม 2540 เรียงตามลำดับจากมากไปน้อย 5 อันดับใส่ลำดับด้วย รวมถึงราคาเฉลี่ยที่ขายให้ลูกค้าทั้งหมดด้วย
SELECT TOP 5 
       ROW_NUMBER() OVER(ORDER BY SUM(od.Quantity) DESC) AS Rank,
       p.ProductName,
       SUM(od.Quantity) AS TotalQuantity,
       SUM(od.UnitPrice*od.Quantity) AS TotalAmount,
       AVG(od.UnitPrice) AS AvgPrice
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE MONTH(o.OrderDate) = 1 AND YEAR(o.OrderDate) = 1997
GROUP BY p.ProductName
ORDER BY TotalQuantity DESC;
-- 6.   จงแสดงชื่อพนักงาน จำนวนใบสั่งซื้อ ยอดเงินรวมทั้งหมด ที่พนักงานแต่ละคนขายได้ ในเดือน ธันวาคม 2539 โดยแสดงเพียง 5 อันดับที่มากที่สุด
SELECT TOP 5 
       e.FirstName + ' ' + e.LastName AS EmployeeName,
       COUNT(o.OrderID) AS OrdersCount,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = 12 AND YEAR(o.OrderDate) = 1996
GROUP BY e.FirstName, e.LastName
ORDER BY TotalAmount DESC;

-- 7.   จงแสดงรหัสสินค้า ชื่อสินค้า ชื่อประเภทสินค้า ที่มียอดขาย สูงสุด 10 อันดับแรก ในเดือน ธันวาคม 2539 โดยแสดงยอดขาย และจำนวนที่ขายด้วย
SELECT TOP 10 
       p.ProductID, p.ProductName, c.CategoryName,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount,
       SUM(od.Quantity) AS TotalQuantity
FROM [Order Details] od
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages' AND MONTH(o.OrderDate)=12 AND YEAR(o.OrderDate)=1996
GROUP BY p.ProductID, p.ProductName, c.CategoryName
ORDER BY TotalAmount DESC;

-- 8.   จงแสดงหมายเลขใบสั่งซื้อ ชื่อบริษัทลูกค้า ที่อยู่ เมืองประเทศของลูกค้า ชื่อเต็มพนักงานผู้รับผิดชอบ ยอดรวมในแต่ละใบสั่งซื้อ จำนวนรายการสินค้าในใบสั่งซื้อ และเลือกแสดงเฉพาะที่จำนวนรายการในใบสั่งซื้อมากกว่า 2 รายการ
SELECT o.OrderID, c.CompanyName, c.Address, c.City, c.Country,
       e.FirstName + ' ' + e.LastName AS EmployeeName,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount,
       COUNT(od.ProductID) AS ItemsCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.CompanyName, c.Address, c.City, c.Country, e.FirstName, e.LastName
HAVING COUNT(od.ProductID) > 2;

-- 9.   จงแสดง ชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทร เบอร์แฟกซ์ ยอดที่สั่งซื้อทั้งหมดในเดือน ธันวาคม 2539 แสดงผลเฉพาะลูกค้าที่มีเบอร์แฟกซ์
SELECT c.CompanyName, c.ContactName, c.Phone, c.Fax,
       SUM(od.Quantity*od.UnitPrice) AS TotalPurchase
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE c.Fax IS NOT NULL AND MONTH(o.OrderDate)=12 AND YEAR(o.OrderDate)=1996
GROUP BY c.CompanyName, c.ContactName, c.Phone, c.Fax;
-- 10.  จงแสดงชื่อเต็มพนักงาน จำนวนใบสั่งซื้อที่รับผิดชอบ ยอดขายรวมทั้งหมด เฉพาะในไตรมาสสุดท้ายของปี 2539 เรียงตามลำดับ มากไปน้อยและแสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName,
       COUNT(o.OrderID) AS OrdersCount,
       CAST(SUM(od.Quantity*od.UnitPrice) AS DECIMAL(18,4)) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) IN (10,11,12) AND YEAR(o.OrderDate)=1996
GROUP BY e.FirstName, e.LastName
ORDER BY TotalSales DESC;

-- 11.  จงแสดงชื่อพนักงาน และแสดงยอดขายรวมทั้งหมด ของสินค้าที่เป็นประเภท Beverage ที่ส่งไปยังประเทศ ญี่ปุ่น
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName,
       SUM(od.Quantity*od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages' AND o.ShipCountry='Japan'
GROUP BY e.FirstName, e.LastName;
-- 12.  แสดงรหัสบริษัทตัวแทนจำหน่าย ชื่อบริษัทตัวแทนจำหน่าย ชื่อผู้ติดต่อ เบอร์โทร ชื่อสินค้าที่ขาย เฉพาะประเภท Seafood ยอดรวมที่ขายได้แต่ละชนิด แสดงผลเป็นทศนิยม 4 ตำแหน่ง เรียงจาก มากไปน้อย 10 อันดับแรก
SELECT TOP 10 
       s.SupplierID, s.CompanyName, s.ContactName, s.Phone,
       p.ProductName,
       CAST(SUM(od.Quantity*od.UnitPrice) AS DECIMAL(18,4)) AS TotalAmount
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE c.CategoryName = 'Seafood'
GROUP BY s.SupplierID, s.CompanyName, s.ContactName, s.Phone, p.ProductName
ORDER BY TotalAmount DESC;
-- 13.  จงแสดงชื่อเต็มพนักงานทุกคน วันเกิด อายุเป็นปีและเดือน พร้อมด้วยชื่อหัวหน้า
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName,
       e.BirthDate,
       DATEDIFF(YEAR,e.BirthDate,GETDATE()) AS AgeYears,
       DATEDIFF(MONTH,e.BirthDate,GETDATE()) % 12 AS AgeMonths,
       m.FirstName + ' ' + m.LastName AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID;
-- 14.  จงแสดงชื่อบริษัทลูกค้าที่อยู่ในประเทศ USA และแสดงยอดเงินการซื้อสินค้าแต่ละประเภทสินค้า
SELECT c.CompanyName, cat.CategoryName,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE c.Country='USA'
GROUP BY c.CompanyName, cat.CategoryName;
-- 15.  แสดงข้อมูลบริษัทผู้จำหน่าย ชื่อบริษัท ชื่อสินค้าที่บริษัทนั้นจำหน่าย จำนวนสินค้าทั้งหมดที่ขายได้และราคาเฉลี่ยของสินค้าที่ขายไปแต่ละรายการ แสดงผลตัวเลขเป็นทศนิยม 4 ตำแหน่ง
SELECT s.CompanyName, p.ProductName,
       SUM(od.Quantity) AS TotalQuantitySold,
       CAST(AVG(od.UnitPrice) AS DECIMAL(18,4)) AS AvgPrice
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY s.CompanyName, p.ProductName;
-- 16.  ต้องการชื่อบริษัทผู้ผลิต ชื่อผู้ต่อต่อ เบอร์โทร เบอร์แฟกซ์ เฉพาะผู้ผลิตที่อยู่ประเทศ ญี่ปุ่น พร้อมทั้งชื่อสินค้า และจำนวนที่ขายได้ทั้งหมด หลังจาก 1 มกราคม 2541
SELECT s.CompanyName, s.ContactName, s.Phone, s.Fax,
       p.ProductName,
       SUM(od.Quantity) AS TotalQuantitySold
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE s.Country='Japan' AND o.OrderDate >= '1998-01-01'
GROUP BY s.CompanyName, s.ContactName, s.Phone, s.Fax, p.ProductName;
-- 17.  แสดงชื่อบริษัทขนส่งสินค้า เบอร์โทรศัพท์ จำนวนรายการสั่งซื้อที่ส่งของไปเฉพาะรายการที่ส่งไปให้ลูกค้า ประเทศ USA และ Canada แสดงค่าขนส่งโดยรวมด้วย
SELECT sh.CompanyName, sh.Phone,
       COUNT(o.OrderID) AS OrdersCount,
       SUM(o.Freight) AS TotalFreight
FROM Shippers sh
JOIN Orders o ON sh.ShipperID = o.ShipVia
WHERE o.ShipCountry IN ('USA','Canada')
GROUP BY sh.CompanyName, sh.Phone;
-- 18.  ต้องการข้อมูลรายชื่อบริษัทลูกค้า ชื่อผู้ติดต่อ เบอร์โทรศัพท์ เบอร์แฟกซ์ ของลูกค้าที่ซื้อสินค้าประเภท Seafood แสดงเฉพาะลูกค้าที่มีเบอร์แฟกซ์เท่านั้น
SELECT DISTINCT c.CompanyName, c.ContactName, c.Phone, c.Fax
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE cat.CategoryName='Seafood' AND c.Fax IS NOT NULL;
-- 19.  จงแสดงชื่อเต็มของพนักงาน  วันเริ่มงาน (รูปแบบ 105) อายุงานเป็นปี เป็นเดือน ยอดขายรวม เฉพาะสินค้าประเภท Condiment ในปี 2540
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName,
       e.HireDate,
       DATEDIFF(YEAR,e.HireDate,GETDATE()) AS WorkYears,
       DATEDIFF(MONTH,e.HireDate,GETDATE()) % 12 AS WorkMonths,
       SUM(od.Quantity*od.UnitPrice) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName='Condiments' AND YEAR(o.OrderDate)=1997
GROUP BY e.FirstName, e.LastName, e.HireDate;
-- 20.  จงแสดงหมายเลขใบสั่งซื้อ  วันที่สั่งซื้อ(รูปแบบ 105) ยอดขายรวมทั้งหมด ในแต่ละใบสั่งซื้อ โดยแสดงเฉพาะ ใบสั่งซื้อที่มียอดจำหน่ายสูงสุด 10 อันดับแรก
SELECT TOP 10 
       o.OrderID,
       CONVERT(VARCHAR, o.OrderDate, 105) AS OrderDate,
       SUM(od.Quantity*od.UnitPrice) AS TotalAmount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate
ORDER BY TotalAmount DESC;
