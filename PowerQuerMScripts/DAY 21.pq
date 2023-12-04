let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    Fact_Order = WideWorldImportersDW{[Schema="Fact",Item="Order"]}[Data][[Order Key],[Description],[Quantity]],
    Add_Column = Table.AddColumn(Fact_Order,"Category", each 
                            if [Quantity] < 100 then "Less than 100" else
                            if [Quantity] < 250 then "More than 250" else "Between 100 and 250")
in
    Add_Column
