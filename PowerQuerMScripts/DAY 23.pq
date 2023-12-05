let//Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Fact sales and relevant columns
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data][[Sale Key],[Customer Key], [Salesperson Key], [Description] ],
    //Import Dimension customer and relevant columns
    Dimension_Customer = WideWorldImportersDW{[Schema="Dimension",Item="Customer"]}[Data][[Bill To Customer],[Customer Key] ],
    //Join both tables
    JoinTables = Table.Join(Fact_Sale,"Customer Key",Dimension_Customer,"Customer Key", JoinKind.Inner),
    //Add a helper column
    AddColumn = Table.AddColumn(JoinTables,"SortCol", each if [Bill To Customer] = "N/A" then 0 else 1),
    //Sort Helper column
    #"Sorted Rows" = Table.Sort(AddColumn,{{"SortCol", Order.Descending}}),
    //Remove Helper column
    #"Removed Columns" = Table.RemoveColumns(#"Sorted Rows",{"SortCol"})
in
    #"Removed Columns"
