let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Import Fact_sales table and relevant columns
    Fact_Sale = WideWorldImportersDW{[Schema="Fact",Item="Sale"]}[Data][[Invoice Date Key],[Profit]],
    //Add YYYYMM column
    Add_YYYYMM = Table.AddColumn(Fact_Sale,"YYYYMM", each Date.Year([Invoice Date Key])* 100 + Date.Month([Invoice Date Key]) ,Number.Type),
    //Add Previous Month YYYYMMM
    Add_PreviousYYYYMM =  Table.AddColumn(Add_YYYYMM,"Previous YYYYMM", each  Date.Year(Date.AddMonths([Invoice Date Key], -1))*100 + Date.Month(Date.AddMonths([Invoice Date Key],-1))),
    //Group total profit by YYYYMM and Previous YYYYMM
    #"Grouped Rows" = Table.Group(Add_PreviousYYYYMM, {"YYYYMM", "Previous YYYYMM"}, {{"TotalProfit", each List.Sum([Profit]), type number}}),
    //Left Join same table
    Join_YYYYMM = Table.NestedJoin(#"Grouped Rows","YYYYMM",#"Grouped Rows","Previous YYYYMM", "Results",JoinKind.LeftOuter),
    #"Expanded Results" = Table.ExpandTableColumn(Join_YYYYMM, "Results", {"TotalProfit"}, {"TotalProfit.1"}),
    //Sort YYYYMM ASC
    #"Sorted Rows" = Table.Sort(#"Expanded Results",{{"YYYYMM", Order.Ascending}}),
    //Rename column
    #"Renamed Columns" = Table.RenameColumns(#"Sorted Rows",{{"TotalProfit.1", "Previous TotalProfit"}}),
    //Calculate Percentage change
    Percentage_change = Table.AddColumn(#"Renamed Columns","%Change", each [TotalProfit]/[Previous TotalProfit]-1,Percentage.Type),
    //Remove other columns
    #"Removed Columns" = Table.RemoveColumns(Percentage_change,{"Previous YYYYMM", "Previous TotalProfit"})
in
    #"Removed Columns"
