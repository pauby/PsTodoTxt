$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt

InModuleScope PsTodoTxt {

    Describe "Test-ObjectProperty" {
        $testObj = New-Object -TypeName PSObject -Property @{ firstname = "Luke"; surname = "Skywalker" }

        Context "Invalid parameters provided" {
            It "Should throw an error" {
                { Test-ObjectProperty -InputObject $null -PropertyName "" } | Should throw "argument is null"
                { Test-ObjectProperty -InputObject (New-Object -TypeName PSObject)  $null -PropertyName "" } | Should throw "argument is null or empty"
            }
        }

        Context "Invalid data provided" {
            It "Should return false as object has no valid properties" {
                $result = Test-ObjectProperty -InputObject (New-Object -TypeName PSObject) -PropertyName "firstname"
                $result | Should BeOfType [bool]
                $result | Should Be $false

                $result = $testObj | Test-ObjectProperty -PropertyName "dateofbirth"
                $result | Should BeOfType [bool]
                $result | Should Be $false
            }
        }

        Context "Valid data provided" {
            It "Should return true for valid properties" {
                $result = $testObj | Test-ObjectProperty -PropertyName "firstname"
                $result | Should BeOfType [bool]
                $result | Should Be $true

                $result = Test-ObjectProperty -InputObject $testObj -PropertyName "surname"
                $result | Should BeOfType [bool]
                $result | Should Be $true
            }
        }
    }
}