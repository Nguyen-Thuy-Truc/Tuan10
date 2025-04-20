USE THUCHANH10

SELECT * FROM Products
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM OrderDetails

CREATE TABLE Categories 
(	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(255),
	Description VARCHAR(255))

INSERT INTO Categories VALUES
(1, 'Đồ uống', 'Đồ uống nhẹ, cà phê, trà, bia và bia đen'),
(2, 'Gia vị', 'Nước sốt ngọt và mặn, tương ớt, đồ phết và gia vị'),
(3, 'Bánh kẹo', 'Món tráng miệng, kẹo và bánh mì ngọt'),
(4, 'Sản phẩm từ sữa', 'Phô mai'),
(5, 'Ngũ cốc/Ngũ cốc', 'Bánh mì, bánh quy giòn, mì ống và ngũ cốc'),
(6, 'Thịt/Gia cầm', 'Thịt chế biến'),
(7, 'Sản phẩm', 'Trái cây sấy khô và đậu phụ'),
(8, 'Hải sản', 'Rong biển và cá')

ALTER TABLE Products
ADD CategoryID INT

ALTER TABLE Products
ADD QuantityPerUnit VARCHAR(50)

 
ALTER TABLE Products
ADD UnitsInStock INT

INSERT INTO Products VALUES
(5, 'Espresso', 1, 10000, 55, 1, 'Box', 1000),
(6, 'Trà thảo mộc', 2, 20000, 80, 3, 'Box', 2000),
(7, 'Bánh sô cô la', 3, 30000, 40, 2, 'Box', 1500),
(8, 'Bánh phô mai', 4, 40000, 20, 1, 'Box', 25000)


CREATE VIEW vw_Products_Info AS
SELECT Categories.CategoryName, 
	Categories.Description, 
	Products.ProductName, 
	Products.QuantityPerUnit, 
	Products.UnitPrice, 
	Products.UnitInStock
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
 
SELECT * FROM vw_Products_Info


INSERT INTO Products 
VALUES 
(9, 'Tà tưa', 1, 20, 40, 2, 'Box', 1000),
(10, 'Late', 2, 16, 50, 1, 'Box', 1002),
(11, 'Bánh dâu', 1, 26, 100, 1, 'Box', 1200)

INSERT INTO Orders
VALUES 
(6, 1, 1, '2025-09-18'),
(7, 1, 2, '2025-01-15'),
(8, 3, 2, '2025-04-13')


INSERT INTO OrderDetails 
VALUES 
(6, 9, 16, 2, 0.10),
(7, 10, 20,1, 0.05),
(8, 11, 26, 5, 0.01)

CREATE VIEW List_Product_view AS
SELECT Products.ProductID,
		Products.ProductName,
		Products.UnitPrice,
		Products.QuantityPerUnit,
		COUNT(OrderDetails.OrderID) AS ORDER_COUNT
FROM Products
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
WHERE Products.QuantityPerUnit LIKE '%Box%' AND Products.UnitPrice > 16
GROUP BY Products.ProductID, Products.ProductName, Products.UnitPrice, Products.QuantityPerUnit

SELECT * FROM List_Product_view

CREATE VIEW vw_CustomerTotals AS
SELECT Orders.CustomerID, 
		YEAR(Orders.OrderDate) AS OrderYear, 
		MONTH(Orders.OrderDate) AS OrderMonth,
		SUM(OrderDetails.UnitPrice*OrderDetails.Quantity) AS Totals
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = Orders.OrderID
GROUP BY  Orders.CustomerID,  YEAR(Orders.OrderDate), MONTH(Orders.OrderDate)

SELECT * FROM vw_CustomerTotals

CREATE VIEW vw_Employee WITH ENCRYPTION AS
SELECT Orders.EmployeeID, 
		YEAR(Orders.OrderDate) AS OrderYear,
		SUM(OrderDetails.Quantity) AS sumOfOrderQuantity
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.EmployeeID, YEAR(Orders.OrderDate)
		
SELECT * FROM vw_Employee


INSERT INTO Orders 
VALUES 
(9, 2, 1, '1997-02-15'),
(10, 1, 2, '1997-03-20'),
(11, 1, 3, '1997-04-25'),
(12, 2, 4, '1997-05-30'),
(13, 1, 5, '1997-06-15')


CREATE VIEW ListCustomer_view AS
SELECT Orders.CustomerID,
	Customers.CompanyName,
	COUNT(Orders.OrderID) AS CountOfOrders
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(Orders.OrderDate) BETWEEN 1997 AND 1998
GROUP BY Orders.CustomerID, Customers.CompanyName
HAVING COUNT(Orders.OrderID) > 5

SELECT * FROM ListCustomer_view


INSERT INTO Categories  
VALUES
(9, 'Beverages','Đồ uống'),
(10, 'Seafood','Đồ ăn')

INSERT INTO Products 
VALUES
(12, 'Chai', 1, 25, 60, 9, 'Box', 1002),
(13, 'Chang', 1, 34, 120, 10, 'Box', 1200),
(14, 'Ikura', 2, 45, 100, 9, 'Box', 1000)

INSERT INTO OrderDetails
VALUES
(8, 12, 100, 31, 0.00),
(9, 13, 200, 40, 0.05),
(10, 14, 300, 50, 0.10)

CREATE VIEW ListProduct_view AS
SELECT Categories.CategoryName,
       Products.ProductName,
       YEAR(Orders.OrderDate) AS OrderYear,
       SUM(OrderDetails.Quantity) AS sumOfOrderQuantity
FROM Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
INNER JOIN Orders ON Orders.OrderID = OrderDetails.OrderID
WHERE Categories.CategoryName IN ('Beverages', 'Seafood')
GROUP BY Categories.CategoryName, Products.ProductName, YEAR(Orders.OrderDate)
HAVING SUM(OrderDetails.Quantity) > 30

SELECT * FROM ListProduct_view

CREATE VIEW vw_OrderSummary WITH ENCRYPTION AS
SELECT YEAR(Orders.OrderDate) AS OrderYear,
		MONTH(Orders.OrderDate) As OrderMonth,
		SUM(OrderDetails.UnitPrice*OrderDetails.Quantity) AS OrderTotal
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY YEAR(Orders.OrderDate), MONTH(Orders.OrderDate)

SELECT * FROM vw_OrderSummary

ALTER TABLE Products
ADD Discount DECIMAL(5, 2)

CREATE VIEW vw_Products WITH ENCRYPTION AS
SELECT Products.ProductID,
		Products.ProductName,
		Products.Discount
FROM Products

SELECT * FROM vw_Products

CREATE VIEW vw_Customer
WITH CHECK OPTION AS
SELECT Customers.CustomerID,
       Customers.CompanyName,
      Customers.City
FROM Customers
WHERE Customers.City IN ('London', 'Madrid')

SELECT * FROM vw_Customer

CREATE VIEW vw_Customer AS
SELECT CustomerID, CompanyName, City FROM Customers
WHERE City IN ('London', 'Madrid')
WITH CHECK OPTION

CREATE TABLE KhachHang_Bac
(	MaKh INT PRIMARY KEY,
	TenKH VARCHAR(350),
	DiaChi VARCHAR(350),
	KhuVuc VARCHAR(350) CHECK (KhuVuc = 'Bac Bo'))

CREATE TABLE KhachHang_Nam
(	MaKh INT PRIMARY KEY,
	TenKH VARCHAR(350),
	DiaChi VARCHAR(350),
	KhuVuc VARCHAR(350) CHECK (KhuVuc = 'Nam Bo'))

CREATE TABLE KhachHang_Trung
(	MaKh INT PRIMARY KEY,
	TenKH VARCHAR(350),
	DiaChi VARCHAR(350),
	KhuVuc VARCHAR(350) CHECK (KhuVuc = 'Trung Bo'))

INSERT INTO KhachHang_Bac (MaKH, TenKH, DiaChi, KhuVuc)
VALUES 
(1, 'Nguyen Van Manh', 'Hanoi', 'Bac Bo'),
(2, 'Tran Thi Nhi', 'Hai Phong', 'Bac Bo'),
(3, 'Le Van Man', 'Ha Long', 'Bac Bo')

INSERT INTO KhachHang_Trung (MaKH, TenKH, DiaChi, KhuVuc)
VALUES 
(4, 'Pham Van Minh', 'Da Nang', 'Trung Bo'),
(5, 'Nguyen Thi Le', 'Hue', 'Trung Bo'),
(6, 'Tran Van Vinh', 'Quang Nam', 'Trung Bo')

INSERT INTO KhachHang_Nam (MaKH, TenKH, DiaChi, KhuVuc)
VALUES 
(7, 'Le Thi Nho', 'Ho Chi Minh', 'Nam Bo'),
(8, 'Nguyen Van Nghia', 'Can Tho', 'Nam Bo'),
(9, 'Tran Thi Linh', 'Vung Tau', 'Nam Bo')

CREATE VIEW partition_view AS
SELECT * FROM KhachHang_Bac
UNION ALL
SELECT * FROM KhachHang_Trung
UNION ALL
SELECT * FROM KhachHang_Nam

SELECT * FROM partition_view

CREATE VIEW Products_Box AS
SELECT * FROM Products
WHERE QuantityPerUnit LIKE '%Box%'

SELECT * FROM Products_Box

INSERT INTO Products
VALUES
(15, 'Muối', 1, 9, 60, 9, 'Box', 1002,0.01),
(16, 'Mắm', 1, 5, 100, 10, 'Box', 1200, 0.05)

CREATE VIEW Products_10 AS
SELECT * FROM Products
WHERE UnitPrice < 10

SELECT * FROM Products_10

CREATE VIEW Products_Avg AS
SELECT * FROM Products
WHERE UnitPrice >= (SELECT AVG(UnitPrice) FROM Products)

SELECT * FROM Products_Avg

CREATE VIEW Customer_Orders AS
SELECT Customers.CustomerID AS CustID,
       Customers.CompanyName,
       Orders.OrderID,
       Orders.EmployeeID,
       Orders.OrderDate,
       OrderDetails.OrderID AS OrderDetailID,
       OrderDetails.ProductID,
       OrderDetails.UnitPrice,
       OrderDetails.Quantity,
       OrderDetails.Discount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID

SELECT * FROM Customer_Orders

EXEC sp_helpindex 'Orders'
DROP INDEX PK__Orders__C3905BAFD6A7E6BA ON Orders 

CREATE CLUSTERED INDEX Orders_CustomerID
ON Orders (CustomerID)
sp_helpindex 'Orders'
SELECT * FROM Orders
--- KHONG TAO DUOC VI BANG Orders DA CO KHOA CHINH (PK - CLUSTERED INDEX ) NEN KHI CHEN NAY DU LIEU SE KHONG NHAN MA NEN CHUYEN SANG NONCLUSTERED ---

CREATE NONCLUSTERED INDEX Orders_EmployeeID
ON Orders (EmployeeID)
--- NONCLUSTERD INDEX -> CHI VI TRI CUA DU LIEU THOI CHU KHONG SAP XEP THEO DU LIEU NHU CLUSTERED INDEX---
sp_helpindex 'Orders'
SELECT * FROM Orders
--- KET QUA SE KHONG THAY DOI MA CHI TANG TOC DO DUYET ---

ALTER TABLE Orders
ADD DiemTL INT
CREATE UNIQUE INDEX Orders_DiemTL
ON Orders (DiemTL)
--- NEU TAO DU LIEU CUNG DIEM TICH LUY SE KHONG DUOC VI VI PHAM RANG BUOC DUY NHAT---

SELECT * FROM Orders WHERE orderdate = GETDATE()
CREATE NONCLUSTERED INDEX Orders_OrderDate
ON Orders(orderdate)

SELECT * FROM Products WHERE ProductID = 57
CREATE NONCLUSTERED INDEX Products_ProductId 
ON Products(ProductID)
		


