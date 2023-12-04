let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data], 
    dbo_FactResellerSales = AdventureWorksDW2017{[Schema="dbo",Item="FactResellerSales"]}[Data][[SalesOrderNumber],[OrderDate],[ResellerKey],[EmployeeKey]],
    AddUnixTimeStamp= Table.AddColumn(dbo_FactResellerSales,"UnixTimeStamp", each Duration.TotalSeconds([OrderDate] - DateTime.FromText("1970-01-01 00:00:00")))
in
    AddUnixTimeStamp
