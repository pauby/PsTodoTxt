Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        $testDate = "2016-07-01"
        Mock Get-TodoTxtTodaysDate { return $testDate }

        It "Should return an object with the CreatedDate property" {
            $actual = New-TodoTxtObject
            $expected = New-Object -TypeName PSObject -Property @{ CreatedDate = $testDate }
            Compare-Object -ReferenceObject $actual -DifferenceObject $expected -Property CreatedDate | Should Be $null
        }
    }
}