let
  //Source Datasets from Database
    Source = Sql.Databases("DAGDAN\SQLEXPRESS"),
    AdventureWorksDW2017 = Source{[Name="AdventureWorksDW2017"]}[Data],
    // Import DimReseller table
    dbo_DimReseller = AdventureWorksDW2017{[Schema="dbo",Item="DimReseller"]}[Data],
    //Select the relevant columns
    #"Remove Other Columns" =Table.SelectColumns(dbo_DimReseller,{
        "ResellerKey",
        "GeographyKey",
        "BusinessType",
        "ResellerName",
        "NumberEmployees",
        "ProductLine",
        "AnnualRevenue"
    }),
    //Filter Reseller Column
    #"Filter Column: DimReseller" = Table.SelectRows(#"Remove Other Columns", each Text.Contains([ResellerName],"Bike") or Text.Contains([ResellerName],"Bicycle")),

    //Import DimGeography table
     dbo_DimGeography = AdventureWorksDW2017{[Schema="dbo",Item="DimGeography"]}[Data],

     // Select the relevant columns
      #"Remove Other Columns:Geography" =Table.SelectColumns(dbo_DimGeography,{
        "GeographyKey",
        "EnglishCountryRegionName",
        "CountryRegionCode"
      }),
    
    //Filter CountryReginCode column
    #"Filter Column:Geography" = Table.SelectRows(#"Remove Other Columns:Geography", each not List.Contains({"DE","GB"},[CountryRegionCode])),

    //Join DimResell and DimGeography
    #"Join DimReseller & DimGeography" = Table.Join(#"Filter Column: DimReseller","GeographyKey",#"Filter Column:Geography","GeographyKey",JoinKind.Inner),
    
    //Select the relevant Columns that answers the question
    #"Choose Columns" = Table.SelectColumns(#"Join DimReseller & DimGeography",{
      "ResellerKey",
      "BusinessType",
      "ResellerName",
      "NumberEmployees",
      "ProductLine",
      "AnnualRevenue" }
         )
in
    #"Choose Columns"
