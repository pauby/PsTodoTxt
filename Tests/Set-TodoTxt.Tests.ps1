$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt

Describe "Set-TodoTxt" {

    InModuleScope PsTodoTxt {

        Context "Invalid input supplied" {
 <#           It "Should throw an exception for no input" {
                { Set-TodoTxt } | Should throw "InputObject"
            }
#>
            It "Should throw an exception for invalid input" {
                { (New-Object -TypeName PSObject) | Set-TodoTxt } | Should throw "Task"

            }
<#


                        $actual = Split-TodoTxt "x 2016-07-07 2015-10-10"
                $result = @{ DoneDate = "2016-07-07"; CreatedDate = "2016-05-05"; Task = "2015-10-10" }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable
                Compare-Object $actualObj $resultObj -Property DoneDate, Priority, CreatedDate, Task, Context, Project, Addon | Should Be $null
#>      }
    }
}
