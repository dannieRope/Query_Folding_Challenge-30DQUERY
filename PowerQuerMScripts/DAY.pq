let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Select table and relevant Column
    #"Dimension_Stock Item" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data],
    //List Columns of text type
    ListColumns = Table.ColumnsOfType(#"Dimension_Stock Item",{Text.Type}),
    //Select columns of text type
    ColumnsTextype = Table.SelectColumns(#"Dimension_Stock Item",ListColumns)
in
    ColumnsTextype
