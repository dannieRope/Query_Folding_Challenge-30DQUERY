let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS"),

    // Import DimProduct Table
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimProduct = AdventureWorksDW2017{[Schema="dbo",Item="DimProduct"]}[Data],
    // Select the columns needed
    #"Remove Other Columns:DimProduct" = Table.SelectColumns(dbo_DimProduct,{
        "ProductKey",
        "EnglishProductName"}
    ),
    //Import FactResellerSales
     dbo_FactResellerSales = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data],
     // Select the columns needed
     #"Remove Other Columns:FactResellerSales" = Table.SelectColumns(dbo_FactResellerSales,{
         "ProductKey",
         "UnitPrice",
         "OrderQuantity"
     }),
     //Add column (TotalUnitPrice)
     #"Add Column TotalUnitPrice" = Table.AddColumn(#"Remove Other Columns:FactResellerSales","TotalUniPrice",each [UnitPrice]*[OrderQuantity]),
     //Group TotalUnitPrice by ProductKey and Name column "TotalRevenue     
     #"Grouped Rows:" = Table.Group(#"Add Column TotalUnitPrice", {"ProductKey"}, {{"TotalRevenue", each List.Sum([TotalUniPrice]), Currency.Type}}),
     //Join Group by table and Dimproduct
     #"Join Grouped Rows & DimProduct" = Table.Join(#"Remove Other Columns:DimProduct","ProductKey",#"Grouped Rows:","ProductKey"),
     //Filter the table
     #"Filtered Rows" = Table.SelectRows(#"Join Grouped Rows & DimProduct",each [TotalRevenue]>1000000)
in
    #"Filtered Rows"
