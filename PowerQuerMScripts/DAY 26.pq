let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimEmployee = AdventureWorksDW2017{[Schema="dbo",Item="DimEmployee"]}[Data] [[EmployeeKey], [FirstName], [MiddleName], [LastName]],
    List = { "A" , "B" , "C" , "D" , "E"},
    LastName = Table.Column(dbo_DimEmployee,"LastName"),
    FilterLastName = List.Select(LastName, each List.Contains(List,Text.Start(_,1))),
    FilterbyLastName = Table.SelectRows(dbo_DimEmployee, each not List.Contains(FilterLastName,[LastName]))
in
    FilterbyLastName
