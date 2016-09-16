Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing mandatory parameters input" {   
            It "Passes testing for null and / or missing mandatory parameter" { 
                { ConvertFrom-TodoTxtString -Todo $null } | Should throw "null or empty"   
                { ConvertFrom-TodoTxtString -Todo (New-Object -Typename PSObject) } | Should throw "null or empty"
            }
        }

        Context "Testing function processing and logic" {
            $invalidStringArr = @( "2016-10-99 Go to Ewok planet",
                "x 2016-88-10 Go to Ewok planet @deathstar",
                "2016-01-01 @deathstar +ewok",
                "2016-01-10 +ewok",
                "x 2016-01-01 Go to Ewok planet @@deathstar ++ewok"
                )

            $validStringArr = @( "2016-10-09 Go to Ewok planet",
                "x 2016-08-10 Go to Ewok planet @deathstar",
                "2016-01-01 Go to Ewok planet @deathstar +ewok",
                "x 2016-01-01 Go to Ewok planet @deathstar +ewok"
                )

            $validStringOutput = ( 
                (New-Object -TypeName PSObject -Property @{ CreatedDate="2016-10-09"; Task = "Go to Ewok planet" }),
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-08-10"; Task = "Go to Ewok planet"; Context = "deathstar"}),
                (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"}),
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"})
            ) 

            It "Passes testing of invalid data" {
                $invalidStringArr | ForEach-Object {
                    { $_ | ConvertFrom-TodoTxtString } | Should throw "Cannot validate argument"
                }
            }

            It "Passes testing of valid data" {

            }
        }
    }
}