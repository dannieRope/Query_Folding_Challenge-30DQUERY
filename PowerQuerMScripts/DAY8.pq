let //source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Fact.Sales table
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data],
    //Select Relevant Columns
    #"Remove Other Columns" = Table.SelectColumns(Fact_Sale,{
        "Sale Key",
        "Customer Key",
        "Invoice Date Key",
        "Total Excluding Tax",
        "Tax Amount",
        "Profit"
    }),
    //Filter Invoice Date Key column by the condition given
    #"Filtered Rows" = Table.SelectRows(#"Remove Other Columns", each [Invoice Date Key] = Date.EndOfMonth([Invoice Date Key]))
in
    #"Filtered Rows"
