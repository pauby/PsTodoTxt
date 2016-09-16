Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PsTodoTxt {
        It "Should throw an exception for null / empty input" {
            { Test-TodoTxtDate -Date "" } | Should throw "argument is null or empty"
        }

        It "Passess all tests for valid and invalid data" {
            $actual = Test-TodoTxtDate -Date "2917-ss-8j"
            $actual | Should Be $false
            $actual | Should BeOfType boolean

            $actual = Test-TodoTxtDate -Date "28-01-1974"
            $actual | Should Be $false
            $actual | Should BeOfType boolean

            $actual = Test-TodoTxtDate -Date "1974-01-28"
            $actual | Should Be $true
            $actual | Should BeOfType boolean

            $actual = Test-TodoTxtDate -Date "2017-09-88"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }
    }
}