Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing parameters against invalid data" {
            It "Fail when passed empty data" {
                { ConvertFrom-TodoTxtString -Todo $null } | Should throw "argument is null"
            }
        }

        Context "Testing output against valid input" {
            $todoTxt = @( "2017-09-88 Lets go to the Degobah system",
                            "x 2015-10-09 LEIA! +rebels +hoth @deathstar due:2018-09-09",
                            "(g) You're a little short to be a stormtrooper? @deathstar +prison")
            $todaysDate = "2016-09-15"
            Mock Get-TodoTxtTodaysDate { Write-Output $todaysDate }

            It "Passes when passed a single valid TodoTxt string" {
                $expected = New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" }
                $actual = ConvertFrom-TodoTxtString -Todo $todoTxt[0]
                $actual | Should BeOfType Object
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected -Property CreatedDate, Task | Should Be $null
            }

            It "Passes when passed multiple valid TodoTxt strings" {
                $expected = @( (New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" } ),
                    (New-Object -TypeName PSObject -Property @{ DoneDate = "2015-10-09"; CreatedDate = $todaysDate; Task = "LEIA!"; Context = "deathstar"; Project = @("rebels", "hoth"); Addon = @{ due = "2018-09-09"} } ),
                    (New-Object -TypeName PSObject -Property @{ CreatedDate = $todaysDate; Priority = "G"; Task = "You're a little short to be a stormtrooper?"; Context = "deathstar"; Project = "prison" } )
                    )
                $actual = ConvertFrom-TodoTxtString -Todo $todoTxt
                write-host $todoTxt
                Write-Output -NoEnumerate $actual | Should BeOfType Array
                ($actual.Count -eq $expected.Count) | Should be $true
                Compare-Object -ReferenceObject $actual[0] -DifferenceObject $expected[0] -Property CreatedDate, Task | Should Be $null
                Compare-Object -ReferenceObject $actual[1] -DifferenceObject $expected[1] -Property DoneDate, CreatedDate, Task, Context, Project, Addon | Should Be $null
                Compare-Object -ReferenceObject $actual[2] -DifferenceObject $expected[2] -Property CreatedDate, Priority, Task, Context, Project | Should Be $null
                $actual | ForEach-Object {
                    $_ | Should BeOfType Object
                }
            }
        }
    }
}