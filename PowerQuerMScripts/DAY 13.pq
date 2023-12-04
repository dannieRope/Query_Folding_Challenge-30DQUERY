let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Import DimEmployee Table 
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    //Select Relavant columns to answer business question
    #"Remove Other Columns" = Table.SelectColumns(dbo_DimEmployee,{
        "EmailAddress",
        "Gender",
        "BirthDate"
    }),
    //Filter BirthDate
    #"Filtered Rows" = Table.SelectRows(#"Remove Other Columns", each [BirthDate] >= #date(1990, 1, 1) and [BirthDate] <= #date(1990, 12, 31))
in
    #"Filtered Rows"
