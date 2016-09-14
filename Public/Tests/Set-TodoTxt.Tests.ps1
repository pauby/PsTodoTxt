Describe "Testing Function - $($Function.Name) - Functional Processing" {
    InModuleScope PSTodoTxt {
        # empty object to be used for testing
        $emptyObj = New-Object -TypeName psobject
        $testDoneDate = "2016-09-09"

        Context "Testing Mandatory Parameter - Todo" {
            It "Should throw an exception for null mandatory parameter" {
                { Set-TodoTxt -Todo $null } | Should throw "argument is null"
            }
        }

        Context "Testing Mandatory Parameter - Task" {
            It "Should throw an exception for missing Task parameter" {
                { Set-TodoTxt -Todo $emptyObj } | Should throw "Task property"
            }

            It "Should pass for mandatory parameters Todo and Task" {
                $expected = New-Object -Typename PSObject -Property @{ Task = "Test task" }
                $actual = Set-TodoTxt -Todo $emptyObj -Task "Test task"
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected -Property Task | Should Be $null
            }
        }

        Context "Testing Parameter - DoneDate" {
            It "Should throw an exception for invalid value" {
                { Set-TodoTxt -Todo $emptyObj -DoneDate "20160987" } | Should throw "Cannot validate argument on parameter"
            }
            
            It "Should return a valid TodoTxt object" {
                $expected = New-Object -Typename PSObject -Property @{ Task = "Test task" }
                $actual = Set-TodoTxt -Todo $emptyObj -Task "Test task"                
            }
    }
<#            It "Should return "

            It "DoneDate Parameter - Should throw an exception "
        }
<#
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
        } #>
    }
}