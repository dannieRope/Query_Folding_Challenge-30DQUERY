let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimCustomer = AdventureWorksDW2017{[Schema="dbo",Item="DimCustomer"]}[Data],
    #"Remove Other Columns:DimCustomer" = Table.SelectColumns(dbo_DimCustomer,{ 
        "CustomerKey",
        "EnglishEducation",
        "Gender",
        "CommuteDistance"
    }),
    dbo_FactInternetSales = AdventureWorksDW2017{[Schema="dbo",Item="FactInternetSales"]}[Data],
    #"Remove Other Columns:FactSales" = Table.SelectColumns(dbo_FactInternetSales,{
        "CustomerKey",
        "OrderQuantity"
    }),
    #"Join DimCustomer&Factsales" = Table.Join(#"Remove Other Columns:DimCustomer","CustomerKey", #"Remove Other Columns:FactSales","CustomerKey",JoinKind.Inner),
    #"List CummuteDistance" = List.Sort(List.Distinct(Table.Column(#"Join DimCustomer&Factsales","CommuteDistance")),each _ <> "10+ Miles"),
    #"Reorder List CummuteDistance" = List.Reverse(#"List CummuteDistance"),
    #"Pivot CommuteDistance" = Table.Pivot(#"Join DimCustomer&Factsales",#"Reorder List CummuteDistance","CommuteDistance","OrderQuantity",List.Sum),
    #"Add Column" = Table.AddColumn(#"Pivot CommuteDistance","SortEducation", each 
                                     if [EnglishEducation] = "Graduate Degree" then 5 else 
                                     if [EnglishEducation] = "Bachelors" then 4 else 
                                     if [EnglishEducation] = "Partial College" then 3 else 
                                     if [EnglishEducation] = "High School" then 2 else 
                                     if [EnglishEducation] = "Partial High School" then 1 else null,  Int64.Type),
    #"Sorted Rows" = Table.Sort(#"Add Column",{{"SortEducation", Order.Descending}, {"Gender", Order.Ascending}}),
    #"Remove Columns" = Table.RemoveColumns(#"Sorted Rows",{
        "SortEducation",
        "CustomerKey"
    })
in
    #"Remove Columns"
