Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PsTodoTxt {
        It "Should throw an exception for null / empty input" {
            { Test-TodoTxtPriority -Priority "" } | Should throw "argument is null or empty"
        }

        It "Should return a boolean false for invalid priority" {
            $actual = Test-TodoTxtPriority -Priority "9"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean true for uppercase priority" {
            $actual = Test-TodoTxtPriority -Priority "A"
            $actual | Should Be $true
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean true for lowercase priority" {
            $actual = Test-TodoTxtPriority -Priority "z"
            $actual | Should Be $true
            $actual | Should BeOfType boolean
        }
    }
}