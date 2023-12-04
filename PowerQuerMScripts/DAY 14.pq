let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimCustomer = AdventureWorksDW2017{[Schema="dbo",Item="DimCustomer"]}[Data],
    //Select Relevant Columns
    #"Remove Other Columns" = Table.SelectColumns(dbo_DimCustomer,{
        "CustomerKey",
        "EmailAddress",
        "EnglishOccupation",
        "YearlyIncome", 
        "BirthDate"
    }),
    //Filter BirthDate
    #"Filter Rows" = Table.SelectRows(#"Remove Other Columns", each  Date.DayOfWeek([BirthDate]) <> 1 and Date.DayOfWeek([BirthDate]) <> 7),
    //Remove BirthDate column
    #"Removed Columns" = Table.RemoveColumns(#"Filter Rows",{"BirthDate"})
 
in 
    #"Removed Columns"
