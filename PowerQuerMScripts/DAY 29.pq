let //Source
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Fact_sales
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data],
    //Add Invoice Year Column
    AddColumn = Table.AddColumn(Fact_Sale,"Invoice Year", each Date.Year([Invoice Date Key]),Date.Type),
    //Count distinct Invoice Years
    ListofInvoiceYears =List.Count( List.Distinct(AddColumn[Invoice Year])),
    //Partition table
    PartitionTable = Table.Partition(AddColumn,"Invoice Year", ListofInvoiceYears, each _),
    //Combine all partition tables
    CombinePartitionTables = Table.Combine(PartitionTable)
   
in
    CombinePartitionTables
