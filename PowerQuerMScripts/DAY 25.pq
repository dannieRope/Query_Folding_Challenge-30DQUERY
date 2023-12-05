let//Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Fact Transaction table and relevant columns
    Fact_Transaction = WideWorldImportersDW{[Schema="Fact",Item="Transaction"]}[Data][[Supplier Key],[Is Finalized] ],
    //Import Dimension_Supplier and relevant Columns
    Dimension_Supplier = WideWorldImportersDW{[Schema="Dimension",Item="Supplier"]}[Data][ [Supplier Key] ,[Supplier Reference] , [Supplier], [Category], [Primary Contact] ],
    //Join both tables
    JoinTables = Table.Join(Fact_Transaction,"Supplier Key",Dimension_Supplier,"Supplier Key", JoinKind.Inner),
    //Add Supplier Key Reference Column
    AddColumn = Table.AddColumn(JoinTables,"Supplier Key Reference", each Text.From([Supplier Key]) & "-" & [Supplier Reference]),
    //Filter table
    FilterRows = Table.SelectRows(AddColumn, each [Is Finalized]= true and [Supplier] <> "Unknown"  )
in
    FilterRows
