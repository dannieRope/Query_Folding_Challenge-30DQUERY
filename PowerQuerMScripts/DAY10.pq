let
    Source = Sql.Databases("DAGDAN\SQLEXPRESS", [CreateNavigationProperties=false]),
    WideWorldImportersDW = Source{[Name="WideWorldImportersDW"]}[Data],
    //dim_employee table
    Dimension_Employee = WideWorldImportersDW{[Schema="Dimension",Item="Employee"]}[Data],
    //Keep relavant column
    #"Removed Other Columns" = Table.SelectColumns(Dimension_Employee,{"WWI Employee ID", "Employee"}),
    //Remove duplicates
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns"),
    //Get employees with even employeeIDs
    #"Even Employees" = Table.SelectRows(#"Removed Duplicates",each Number.Mod([WWI Employee ID],2)=0),
    //Get employees with odd employeeIds
    #"Odd Employees" = Table.SelectRows(#"Removed Duplicates",each Number.Mod([WWI Employee ID],2)<>0),
    //Add costum column and add+1 to the odd employee ids
    #"Add New EmployeeID: Odd Employees" = Table.AddColumn(#"Odd Employees","NewEmployeeID", each [WWI Employee ID]+1,Number.Type),
    //Keep relevant column
    #"Removed Columns:Odd Employees" = Table.RemoveColumns(#"Add New EmployeeID: Odd Employees",{"WWI Employee ID"}),
    //Rename columns
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns:Odd Employees",{{"Employee", "Teamates"}}),
    //Join old and even table to get even employees and their odd team mates
    #"Odd ID teamates" = Table.Join(#"Even Employees","WWI Employee ID",#"Renamed Columns","NewEmployeeID",JoinKind.Inner,JoinAlgorithm.SortMerge),
    #"Removed Columns" = Table.RemoveColumns(#"Odd ID teamates",{"WWI Employee ID", "NewEmployeeID"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"Employee", "Team mates"}, {"Teamates", "Employee"}}),
    //Join even and odd table to get odd employes and their even team mates
    #"Even ID teamates" =Table.Join(#"Renamed Columns","NewEmployeeID",#"Even Employees","WWI Employee ID",JoinKind.Inner),
    #"Removed Columns1" = Table.RemoveColumns(#"Even ID teamates",{"NewEmployeeID", "WWI Employee ID"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Removed Columns1",{{"Teamates", "Team mates"}}),
    // Append the two tables
    #"Combine odd an even"= Table.Combine({#"Renamed Columns1",#"Renamed Columns2"})
in
    #"Combine odd an even"
