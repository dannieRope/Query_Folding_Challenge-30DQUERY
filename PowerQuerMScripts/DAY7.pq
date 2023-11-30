let //source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Import dimEployee table
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    //List all columns
    #"List All Columns Names" = Table.ColumnNames(dbo_DimEmployee),
    //Filter for columns that do not contain "Key"
    #"All Columns not contain Key" = List.Select(#"List All Columns Names", each not Text.Contains(_,"Key")),
    //Show a table with columns that do not contain "Key"
    #"Show Columns in Table" = Table.SelectColumns(dbo_DimEmployee,#"All Columns not contain Key")
in
    #"Show Columns in Table"
