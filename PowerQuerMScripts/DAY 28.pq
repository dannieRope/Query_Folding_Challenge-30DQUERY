let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    dbo_DimProduct = AdventureWorksDW2017{[Schema="dbo",Item="DimProduct"]}[Data][[ProductKey], [ProductAlternateKey], [EnglishProductName], [DealerPrice] ],
    FilterRows = Table.SelectRows(dbo_DimProduct, each [DealerPrice] <> null),
    AddColumn = Table.AddColumn(FilterRows, "OverallPercentage", each [DealerPrice]/List.Sum(dbo_DimProduct[DealerPrice])),
    #"Changed Type" = Table.TransformColumnTypes(AddColumn,{{"OverallPercentage", Percentage.Type}})
in
    #"Changed Type"
