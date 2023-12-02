let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //Load Employee table
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    //Load Customer table
    Dimension_Customer = WideWorldImportersDW{[Schema="Dimension",Item="Customer"]}[Data],
    //Select Distinct Primary Contact column and rename as Full Name
    #"Remove Other Columns:Customer" = Table.Distinct(Table.SelectColumns(Dimension_Customer,{"Primary Contact"})),
    #"Rename Column1" = Table.RenameColumns(#"Remove Other Columns:Customer",{{"Primary Contact","Full Name"}}),
    //Select Distinct Employe column and rename as Full Name
    #"Remove Other Columns:Employee" = Table.Distinct(Table.SelectColumns(Dimension_Employee,{"Employee"})),
    #"Rename Column2" = Table.RenameColumns(#"Remove Other Columns:Employee",{{"Employee","Full Name"}}),
    //Combine Both table
    #"Append Tables" = Table.Combine({#"Rename Column1",#"Rename Column2"}),
    //Sort Full Name by ASC
    #"Sorted Rows" = Table.Sort(#"Append Tables",{{"Full Name", Order.Ascending}})
in
    #"Sorted Rows"
