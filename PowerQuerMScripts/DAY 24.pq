let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Dimension transaction type table and relevant columns 
    #"Dimension_Transaction Type" = WideWorldImportersDW{[Schema="Dimension",Item="Transaction Type"]}[Data][[Transaction Type Key],[Transaction Type] ],
    //List of letters
    List = {"a", "e", "i", "o", "u", "y", "w"},
    //List of Values of Transaction type column
    TransactionTypeColumn = Table.Column(#"Dimension_Transaction Type","Transaction Type"),
    //Filter Column value list by the list of letters
    FilterList = List.Select(TransactionTypeColumn, each List.Contains(List, Text.Middle(_,1,1))),
    //Filter Main table with the List
    FilterMaintable = Table.SelectRows(#"Dimension_Transaction Type", each List.Contains(FilterList,[Transaction Type]))
in
    FilterMaintable
