let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS"),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Dimension stock Item table
    #"Dimension_Stock Item" = WideWorldImportersDW{[Schema="Dimension",Item="Stock Item"]}[Data], 
    //Select Relevant Columns
    #"Remove Other Columns" = Table.SelectColumns(#"Dimension_Stock Item",{
        "Stock Item Key",
        "Stock Item",
        "Color"
    }),
    // Filter Column based on conditions provided
    #"Filtered Rows" = Table.SelectRows(#"Remove Other Columns", each Number.Mod([Stock Item Key],2) =0 and [Color] <> "N/A")
in
    #"Filtered Rows"
