ipmo c:\users\paul\sync\coding\repo\pstodotxt\pstodotxt.psd1
Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing parameters input" {
            $invalidTodotxt = New-Object -TypeName PSObject -Property @{ CreatedDate = "2017-09-88"; Task = "Lets go to the Degobah system" }
            $validTodoTxtArr = @( (New-Object -TypeName PSObject -Property @{ DoneDate = "2015-10-09"; CreatedDate = "2016-09-15"; Task = "LEIA!"; Context = "deathstar"; Project = @("rebels", "hoth"); Addon = @{ due = "2018-09-09"} } ),
                    (New-Object -TypeName PSObject -Property @{ CreatedDate = "2016-09-15"; Priority = "G"; Task = "You're a little short to be a stormtrooper?"; Context = "deathstar"; Project = "prison" } )
                    )

            It "Passes testing for null and / or missing mandatory parameter" {
                { Test-TodoTxt -CreatedDate $null } | Should throw "null"
                { Test-TodoTxt -CreatedDate "" } | Should throw "empty"
                { Test-TodoTxt -Task $null } | Should throw "null"
                { Test-TodoTxt -Task "" } | Should throw "empty"
            }

            It "Passes testing for invalid parameters" {
                { $invalidTodoTxt | Test-TodoTxt -ErrorAction Stop } | Should throw "Cannot validate argument"
            }

            It "Passes testing for valid parameters" {
                $validTodoTxtArr | ForEach-Object {
                    $actual = $_ | Test-TodoTxt
                    $actual | Should BeOfType bool
                    $actual | Should Be $true
                }
            }
        }
    }
}