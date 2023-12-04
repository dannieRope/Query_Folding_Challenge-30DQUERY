let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Select FactResellerSales and relevant columns 
    dbo_FactResellerSales = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data][[ProductKey], [SalesOrderNumber],[SalesAmount],[ShipDate]],
    //Filter Sort ShipDate
    SortShipDate = Table.SelectRows(dbo_FactResellerSales, each [ShipDate] = Date.IsInPreviousNYears([ShipDate],7))
in
    SortShipDate
