let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data],
    #"Removed Other Columns" = Table.SelectColumns(dbo_DimEmployee,{"EmployeeKey", "FirstName", "LastName", "MiddleName", "BirthDate", "Gender"}),
    #"Merged Columns" = Table.CombineColumns(#"Removed Other Columns",{"FirstName", "MiddleName", "LastName"},Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"FullName"),
    #"Filtered Rows" = Table.SelectRows(#"Merged Columns", each [BirthDate] >= #date(1974, 1, 1) and [BirthDate] <= #date(1974, 12, 31))
in
    #"Filtered Rows"
