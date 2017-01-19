Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing parameters input" {
            It "Passes testing for null and / or missing mandatory parameter" {
                { Join-TodoTxt -Todo $null } | Should throw "null or empty"
                { Join-TodoTxt -Todo (New-Object -Typename PSObject) } | Should throw "property 'Task'"
            }
        }

        Context "Testing function processing and logic" {
            $todaysDate = "2106-01-01"
            Mock Get-TodoTxtTodaysDate { return $todaysDate }

            $invalidObjArray = (
                (New-Object -TypeName PSObject -Property @{ CreatedDate="2016-99-09"; Task = "Go to Ewok planet" }),
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-88-10"; CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"}),
                (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "@@@deathstar"; Project = "ewok"}),
                (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-01-01"; CreatedDate = "2017-09-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "+ewok"})
            )

            It "Passes testing of invalid data" {
                  $invalidObjArray | ForEach-Object {
                    $errorStream = ""
                    $errorStream = $_ | Join-TodoTxt 2>&1
                    $errorStream | Should BeLike "* invalid."
                }
            }

			It "Passes testing of valid data" {
                $validObjArray = (
                    (New-Object -TypeName PSObject -Property @{ CreatedDate="2016-02-09"; Task = "Go to Ewok planet" }),
                    (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-06-10"; CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"}),
                    (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-01-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"}),
                    (New-Object -TypeName PSObject -Property @{ DoneDate = "2016-01-01"; CreatedDate = "2017-09-01"; Task = "Go to Ewok planet"; Context = "deathstar"; Project = "ewok"})
                )
                $expected = @( "2016-02-09 Go to Ewok planet", "x 2016-06-10 2016-01-01 Go to Ewok planet @deathstar",
                    "2016-01-01 Go to Ewok planet @deathstar +ewok", "x 2016-01-01 2017-09-01 Go to Ewok planet @deathstar +ewok")

			    $actual = $validObjArray | Join-TodoTxt
                @($actual).Count | Should Be $expected.Count
                $actual -is [array] | Should Be $true
                for ($i = 0; $i -lt $actual.Count; $i++) {
                    $actual[$i] -ceq $expected[$i] | Should Be $true
                }
            }
        }
    }
}