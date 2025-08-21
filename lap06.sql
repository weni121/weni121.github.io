SELECT CategoryName, ProductName, UnitPrice
FROM Products as p, Categories as c
WHERE p.CategoryID = c.CategoryID
and CategoryName = 'seafood'

SELECT CategoryName, ProductName, UnitPrice
FROM Products Join Categories
ON Products.CategoryID=Categories.CategoryID
WHERE CategoryName = 'seafood'

SELECT CompanyName, OrderID
FROM Orders, ShipperID = Orders.Shipvia
WHERE Shippers.ShipperID = Order.Shipvia
AND OrderID = 10275

SELECT CompanyName, OrderID
FROM Orders JOIN Shippers
ON Shippers.ShipperID = Order.Shipvia
WHERE OrderID = 10275