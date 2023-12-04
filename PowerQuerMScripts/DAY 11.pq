let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Load DimGeography table
    dbo_DimGeography = AdventureWorksDW2017{[Schema="dbo",Item="DimGeography"]}[Data],
    //Load FactInternetSales table
    dbo_FactInternetSales = AdventureWorksDW2017{[Schema="dbo",Item="FactInternetSales"]}[Data], 
    //Load Customer table
    dbo_DimCustomer = AdventureWorksDW2017{[Schema="dbo",Item="DimCustomer"]}[Data],
    //Rename GeographyKey to GeographyKey1
    #"Rename Column" = Table.RenameColumns(dbo_DimCustomer,{{"GeographyKey","GeographyKey1"}}),
    //Join Dim Geography and Dim_Customer (LEFTJOIN)
    #"Join One" = Table.Join(dbo_DimGeography,"GeographyKey",#"Rename Column","GeographyKey1",JoinKind.LeftOuter),
    //Rename SalesTerritorKey to SalesTerritoryKey1
    #"Rename Column SalesTerritoryKey" = Table.RenameColumns(#"Join One",{{"SalesTerritoryKey","SalesTerritoryKey1"},{"CustomerKey","CustomerKey1"}}),
    //Join table to FactinternetSales (LEFTJOIN)
    #"Join two" = Table.Join(#"Rename Column SalesTerritoryKey","CustomerKey1",dbo_FactInternetSales,"CustomerKey",JoinKind.LeftOuter),
    //Group SalesAmount by multiple columns
    #"Grouped Rows" = Table.Group(#"Join two", {"City", "CountryRegionCode", "EnglishCountryRegionName"}, {{"SalesAmount", each List.Sum([SalesAmount]), type nullable number}}),
    //Filter SalesAmount
    #"Filter Row:SalesAmount" = Table.SelectRows(#"Grouped Rows", each ([SalesAmount]= null) or ([SalesAmount] = 0.00)),
    //Sort by CountryRegionCode and City ASC
    #"Sorted Rows" = Table.Sort(#"Filter Row:SalesAmount",{{"CountryRegionCode", Order.Ascending}, {"City", Order.Ascending}}),
    //Remove SalesAmount
    #"Remove Column" = Table.RemoveColumns(#"Sorted Rows","SalesAmount")
in
    #"Remove Column"
