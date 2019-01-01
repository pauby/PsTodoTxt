Import-HelperModuleForTesting
$functionName = $MyInvocation.MyCommand -split '.tests.ps1'

Describe "Testing Function - $functionName" {

    InModuleScope PSTodoTxt {
        Context "Input" {

            It "Passes testing for null and / or missing mandatory parameter" {
                { Test-ObjectProperty } | Should throw 'parameter'
                { Test-ObjectProperty -InputObject (New-Object -Typename PSObject) } | Should throw 'parameter'
                { Test-ObjectProperty -PropertyName 'Test' } | Should throw 'parameter'
            }

            It "Passes testing for invalid parameters" {
                { Test-ObjectProperty -InputObject $null } | Should throw 'null'
                { Test-ObjectProperty -PropertyName "" } | Should throw 'empty'
            }
        }

        Context "Logic & Flow" {
            $testObj = New-Object -TypeName PSObject -Property @{ forename = 'Luke'; surname = 'Skywalker' }

            It "Passes testing of invalid data" {
                $actual = Test-ObjectProperty -InputObject $testObj -PropertyName 'dob' 
                $actual -is [bool] | Should Be $true
                $actual | Should Be $false
            }
        
			It "Passes testing of valid data" {
                $actual = Test-ObjectProperty -InputObject $testObj -PropertyName 'surname' 
                $actual -is [bool] | Should Be $true
                $actual | Should Be $true
            }
        } #Context
    } #InModuleScope
}