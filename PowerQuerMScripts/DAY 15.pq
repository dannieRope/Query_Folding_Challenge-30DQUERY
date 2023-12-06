let 
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data][[Sale Key],[Delivery Date Key]],
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data][[City Key],[Order Key],[Order Date Key]],
    Dimension_City = WideWorldImportersDW{[Schema="Dimension",Item="City"]}[Data][[City Key],[City]],
    JoinSalesOrder = Table.Join(Fact_Sale,"Sale Key",Fact_Order,"Order Key",JoinKind.Inner),
    JoinCity = Table.NestedJoin(Dimension_City,"City Key",JoinSalesOrder,"City Key","Citytable",JoinKind.LeftOuter),
    #"Expanded Citytable" = Table.ExpandTableColumn(JoinCity, "Citytable", {"Delivery Date Key", "Order Date Key"}, {"Delivery Date Key", "Order Date Key"}),
    CompletedDelivery = Table.SelectRows(#"Expanded Citytable", each [Delivery Date Key] <> null),
    AddColumn = Table.AddColumn(CompletedDelivery,"Delivery Days", each Duration.TotalDays([Delivery Date Key] - [Order Date Key]), Int64.Type),
    #"Grouped Rows" = Table.Group(AddColumn, {"City Key", "City"}, {{"Average Delivery Day", each List.Average([Delivery Days]), type number}}),
    #"Sorted Rows" = Table.Sort(#"Grouped Rows",{{"Average Delivery Day", Order.Descending}}),
    Top10 = Table.FirstN(#"Sorted Rows",10)

    
in
    Top10
