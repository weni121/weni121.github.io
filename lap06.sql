SELECT CategoryName, ProductName, UnitPrice
FROM Products as p, Categories as c
WHERE p.CategoryID = c.CategoryID
and CategoryName = 'seafood'

SELECT CategoryName, ProductName, UnitPrice
FROM Products Join Categories
ON Products.CategoryID=Categories.CategoryID
WHERE CategoryName = 'seafood'

SELECT CompanyName, OrderID
FROM Orders, Shippers ShipperID = Orders Shipvia
WHERE Shippers.ShipperID = Orders.Shipvia
AND OrderID = 10275

SELECT CompanyName, OrderID
FROM Orders JOIN Shippers
ON Shippers.ShipperID = Orders.Shipvia
WHERE OrderID = 10275


SELECT* p.ProductID, s.CategoryName, p.ProductName, s.Country
FROM  Products p joun Suppliers s on p.supplierID = s.SupplierID
WHERE Country in ('usa' 'uk')

Select EmployeeID, FirstName, o.OrderID
from Employee e JOIN Orders o on e EmployeeID = o.EmployeeID
oder by EmployeeID


