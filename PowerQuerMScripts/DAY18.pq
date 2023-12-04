   //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Select Dim_City and relevant columns
    Dimension_City = WideWorldImportersDW{[Schema="Dimension",Item="City"]}[Data][[City Key],[City],[State Province],[Sales Territory]],
    //List Distinct Cities
    SelectCity = List.Distinct(Table.Column(Dimension_City,"City")),
    //Filter List
    SortList = List.Select(SelectCity, each
                                              Text.Contains(_, "A",Comparer.Ordinal) and
                                              Text.Contains(_, "d",Comparer.Ordinal) and  
                                              Text.Contains(_, "C",Comparer.Ordinal)),
    //Filter Rows
    Filter_Rows = Table.SelectRows(Dimension_City, each List.Contains(SortList,[City]))
   
in
    Filter_Rows
