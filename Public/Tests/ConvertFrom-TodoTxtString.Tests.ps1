Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing parameters input" {
            It "Passes testing for null and / or missing mandatory parameter" {
                { ConvertFrom-TodoTxtString -Todo $null } | Should throw "null or empty"
                { ConvertFrom-TodoTxtString -Todo (New-Object -Typename PSObject) } | Should throw "null or empty"
            }
        }

        Context "Testing function processing and logic" {
            $todaysDate = "2106-01-01"
            Mock Get-TodoTxtTodaysDate { return $todaysDate }

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
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-08-10"; CreatedDate = $todaysDate; Task = "Go to Ewok planet"; Context = "deathstar"}),
                (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"}),
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-01-01"; CreatedDate = $todaysDate; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"})
            )

            It "Passes testing of invalid data" {
                $invalidStringArr | ForEach-Object {
                    { $_ | ConvertFrom-TodoTxtString } | Should throw "Cannot validate argument"
                }
            }

			It "Passes testing of valid data" {
				$actual = $validStringArr | ConvertFrom-TodoTxtString

				Write-Output -NoEnumerate $actual | Should BeOfType Array
                $actual.Count | Should Be $validStringOutput.Count
				Compare-Object -ReferenceObject $actual[0] -DifferenceObject $validStringOutput[0] -Property CreatedDate, Task | Should Be $null
                Compare-Object -ReferenceObject $actual[1] -DifferenceObject $validStringOutput[1] -Property DoneDate, CreatedDate, Task, Context | Should Be $null
                Compare-Object -ReferenceObject $actual[2] -DifferenceObject $validStringOutput[2] -Property CreatedDate, Task, Context, Project | Should Be $null
                Compare-Object -ReferenceObject $actual[3] -DifferenceObject $validStringOutput[3] -Property DoneDate, CreatedDate, Task, Context, Project  | Should Be $null
            }
        }
    }
}