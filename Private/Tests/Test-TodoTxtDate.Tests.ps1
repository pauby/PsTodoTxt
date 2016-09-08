Describe "Testing Function - $($Function.Name) - Functional Processing" {
    InModuleScope PsTodoTxt {
        It "Should throw an exception for null / empty input" {
            { Test-TodoTxtDate -Date "" } | Should throw "argument is null or empty"
        }

        It "Should return a boolean false for an invalid date" {
            $actual = Test-TodoTxtDate -Date "2917-ss-8j"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean false for a wrongly formatted date" {
            $actual = Test-TodoTxtDate -Date "28-01-1974"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean true for a correctly formatted date" {
            $actual = Test-TodoTxtDate -Date "1974-01-28"
            $actual | Should Be $true
            $actual | Should BeOfType boolean
        }
    }
}