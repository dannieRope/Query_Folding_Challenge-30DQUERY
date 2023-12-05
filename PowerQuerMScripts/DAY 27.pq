let //source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Import dbo Dimcurrency table
    dbo_DimCurrency = AdventureWorksDW2017{[Schema="dbo",Item="DimCurrency"]}[Data],
    // find 2 instance of 2
    Find2instancesofe = List.RemoveNulls(List.Distinct(List.Transform(dbo_DimCurrency[CurrencyName], each 
                                            if List.Count(Text.PositionOf(_,"e",Occurrence.All)) = 2 then _ else null))),
    //Filter Table
    FilterDimCurrency = Table.SelectRows(dbo_DimCurrency, each List.Contains(Find2instancesofe,[CurrencyName]))
in
    FilterDimCurrency
