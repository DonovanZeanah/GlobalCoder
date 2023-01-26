/****** Script for SelectTopNRows command from SSMS  ******/
SELECT product.[Name] as ProductName
		, productModel.[Name] as ProductModel
		, productCategory.[Name] as ProductCategory
  FROM [SalesLT].[Product] product
  INNER JOIN [SalesLT].[ProductModel] productModel ON product.ProductModelID = productModel.ProductModelID
  INNER JOIN [SalesLT].[ProductCategory] productCategory on product.ProductCategoryID = productCategory.ProductCategoryID