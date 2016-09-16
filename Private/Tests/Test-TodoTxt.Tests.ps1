Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing mandatory parameters" {
            It "Passes mandatory parameters with invalid or missing data" {
                { Test-TodoTxt -CreatedDate $null } | Should throw "null"
                { Test-TodoTxt -CreatedDate "" } | Should throw "empty"
                { Test-TodoTxt -Task $null } | Should throw "null"
                { Test-TodoTxt -Task "" } | Should throw "empty"
            }
        }

        # Because this function just validates parameters using other Test- functions there
        # is not much else to do except test the output is done correctly
        Context "Testing output against valid input" {
            $todoTxtArr = @( (New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" } ),
                    (New-Object -TypeName PSObject -Property @{ DoneDate = "2015-10-09"; CreatedDate = "2016-09-15"; Task = "LEIA!"; Context = "deathstar"; Project = @("rebels", "hoth"); Addon = @{ due = "2018-09-09"} } ),
                    (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-09-15"; Priority = "G"; Task = "You're a little short to be a stormtrooper?"; Context = "deathstar"; Project = "prison" } )
                    )

            It "Passes all tests for valid and invalid input" {
                 { $todoTxtArr[0] | Test-TodoTxt } | Should throw "argument"
                ($todoTxtArr[1] | Test-TodoTxt) | Should Be $true
                ($todoTxtArr[2] | Test-TodoTxt) | Should Be $true
                { $todoTxtArr | Test-TodoTxt } | Should throw
                ((1..2 | ForEach-Object { $todoTxtArr[$_] }) | Test-TodoTxt) | Should Be $true
            }
        }
    }
}