let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    //Import FactCallCenter table and relevant columns
    dbo_FactCallCenter = AdventureWorksDW2017{[Schema="dbo",Item="FactCallCenter"]}[Data][[DateKey],[Shift],[Calls],[AverageTimePerIssue]],
    //Add column for totaltime
    Add_TotalTime = Table.AddColumn(dbo_FactCallCenter,"TotalTime", each [Calls]*[AverageTimePerIssue], Number.Type),
    //Filter for PM rows in Shift column
    FilterRowPM = Table.SelectRows(Add_TotalTime, each Text.Contains([Shift],"PM")),
    //Sort Totaltime by ASC
    #"Sorted Rows" = Table.Sort(FilterRowPM,{{"TotalTime", Order.Ascending}}),
    //Top 10 totaltime
    Top10 = List.MaxN(Table.Column(#"Sorted Rows","TotalTime"),10),
    //Bottom 10 totaltime
    Bottom10=List.MinN(Table.Column(#"Sorted Rows","TotalTime"),10),
    //Combine both list
    Combine_top10_bottom10 = List.Union({Top10,Bottom10}),
    //Filter table by the list
    Combinetable = Table.SelectRows(#"Sorted Rows", each List.Contains(Combine_top10_bottom10,[TotalTime]))
in
    Combinetable
