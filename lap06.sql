SELECT CategoryName, ProductNAme, UnitPrice
From   Products, Categories
WHERE  Products.CategoryID = Categories.CategoryID
AND    CategoryName ='seafood'

SELECT CategoryName, ProductNAme, UnitPrice
From   Products AS p JOIN Categories as c
ON     p.CategoryID = C.CategoryID
WHERE  CategoryName ='seafood'

SELECT * from Orders WHERE OrderID =10250
SELECT * FROM [Order Details] WHERE orderID = 10250

SELECT p.ProductID, p.ProductName, s.CompanyName, s.Country
from Products p join Suppliers s on p.SupplierID = s.SupplierID
Where Country in ('usa','uk')

SELECT e.EmployeeID, FirstName, o.OrderID
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
order by EmployeeID

SELECT  o.OrderID  เลขใบสั่งซื้อ, c.CompanyName ลูกค้า,
        E.FirstName พนักงาน, O.ShipAddress ส่งไปที่
From Orders O   join Customers C on O.CustomerID = C.CustomerID 
                JOIN Employees E on O.EmployeeID = E.EmployeeID

SELECT s.CompanyName, count(*) จำนวนorders
From Shippers s join Orders o on s.ShipperID = o.ShipVia
GROUP BY s.CompanyName
ORDER BY 2 desc

SELECT p.ProductID, p.ProductName, sum(Quantity)จำนวนที่ขายได้
from Products p JOIN [Order Details] od on p.ProductID =od.ProductID
GROUP BY p.ProductID, p.ProductName 

SELECT Distinct  p.ProductID pProductName
FROM Employees e JOIN Orders o on  e.EmployeeID = o.EmployeeID 
                JOIN[Order Details] OD ON O.OrderID = od.OrderID
                JOIN Products p on p.ProductID = od.ProductID
WHERE e.FirstName = 'Nancy'           
 ORDER BY p.ProductID


SELECT distinct s.Country
FROM Customers c JOIN orders o on c.CustomerID = o.CustomerID
                JOIN [Order Details] od on o.OrderID = od.OrderID
                JOIN Products p on p.ProductID = od.ProductID
                JOIN Suppliers s on s.SupplierID = p.SupplierID
WHERE c.CompanyName = 'Around the Horn'


SELECT p.ProductID, p.ProductName, SUM(Quantity)จำนวนที่สั่งซื้อ
FROM Customers c JOIN orders o on c.CustomerID = o.CustomerID
                JOIN [Order Details] od on o.OrderID = od.OrderID
                JOIN Products p on p.ProductID = od.ProductID
WHERE c.CompanyName = 'Around the Horn'
GROUP by p.ProductID, p.ProductName

SELECT o.OrderID, FirstName, ROUND(sum(od.Quantity* od.UnitPrice*(1-Discount)),2) TotalCash
FROM Orders o JOIN Employees e on o.EmployeeID = e.EmployeeID
            JOIN[Order Details] od on o.OrderID = od.OrderID
GROUP by o.OrderID, FirstName