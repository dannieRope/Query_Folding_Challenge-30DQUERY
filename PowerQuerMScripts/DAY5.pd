let
    //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    //add relevant columns
    #"Remove Other Columns" = Table.SelectColumns(Dimension_Employee,{
        "Employee Key",
        "Employee",
        "Is Salesperson",
        "Valid From",
        "Valid To"
    }),
    //Filter rows based on the stated conditions
    #"Filter Rows" = Table.SelectRows(#"Remove Other Columns", each (Date.Year([Valid To]) <> 9999 and [Is Salesperson] = true and Duration.TotalDays(
            [Valid To] - [Valid From] )> 365) 
            or 
            ([Is Salesperson] = false and Date.Year([Valid To]) = 9999)
    )
    
in
    #"Filter Rows"
