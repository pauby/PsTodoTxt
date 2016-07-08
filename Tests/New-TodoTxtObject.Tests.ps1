$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt

Describe "New-TodoTxtObject" {

    $testDate = "2016-07-01"
    Mock Get-TodoTxtTodaysDate { return $testDate }
    
    It "Should return an object with the CreatedDate property" {
        $actual = New-TodoTxtObject
        $expected = New-Object -TypeName PSObject -Property @{ CreatedDate = $testDate }
        Compare-Object -ReferenceObject $actual -DifferenceObject $expected | Should Be $null
    }
}
