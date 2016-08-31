$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt


InModuleScope PsTodoTxt {

    Describe "Set-TodoTxt" {

        Context "Invalid data supplied" {
           It "Should throw an exception for no input" {
                { Set-TodoTxt } | Should throw "InputObject"
            }

            It "Should throw an exception for missing mandatory parameters" {
                { (New-Object -TypeName PSObject) | Set-TodoTxt } | Should throw "Task"

            }
        }

        Context "Valid data supplied" {

            $testDate = "2016-05-05"
            Mock Get-TodoTxtTodaysDate { return $testDate }

            It "Should return an object with parameters" {
                $actual = ConvertFrom-TodoTxtString "x 2016-07-07 2015-10-10"
                $result = @{ DoneDate = "2016-07-07"; CreatedDate = $testDate; Task = "2015-10-10" }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable
                Compare-Object $actualObj $resultObj -Property DoneDate, CreatedDate, Task | Should Be $null
            }
        }
    }
}

Remove-Module PsTodoTxt