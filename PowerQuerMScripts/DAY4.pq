let
    //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    // Import the Fact.Orders table
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data],
    // Choose the columns needed
    #"Remove Other Columns" = Table.SelectColumns(Fact_Order,{
        "Order Key",
        "Description"
    }),
    // Add new column and find the len of each rows of the description column
    #"Add Column" = Table.AddColumn(#"Remove Other Columns","DescriptionLength", each Text.Length([Description])),
    //Filter the "DescriptionLength" column where modulo 10 of the "DescriptionLength equal 1
    #"Filtered Row" = Table.SelectRows(#"Add Column",each Number.Mod([DescriptionLength],10) = 1),
    // Keep only Order Key and Description column
    #"Remove Other Columns again" = Table.SelectColumns(#"Filtered Row",{
        "Order Key",
        "Description"
    })
in
    #"Remove Other Columns again"
