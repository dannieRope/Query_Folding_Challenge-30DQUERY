let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Import dbo_DimPromotion Table
    dbo_DimPromotion = AdventureWorksDW2017{[Schema="dbo",Item="DimPromotion"]}[Data],
    //Transform Column Names
    AddSpace = Table.TransformColumnNames(dbo_DimPromotion, each Text.Combine(Splitter.SplitTextByCharacterTransition({"a".."z"},{"A".."Z"})(_)," "))
in
    AddSpace
