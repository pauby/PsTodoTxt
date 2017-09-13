Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PsTodoTxt {
        Context "Testing Function as per name (Test-TodoTxtContext)" {
            It "Should throw an exception for null / empty input" {
                { Test-TodoTxtContext -Context "" } | Should throw "argument is null or empty"
            }

            It "Should return a boolean false for a single invalid context (starting with @)" {
                $actual = Test-TodoTxtContext -Context "@hello"
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "Should return a boolean false for a single invalid context (containing a space)" {
                $actual = Test-TodoTxtContext -Context "h ello"
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "Should return a boolean false for a invalid context array" {
                $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "@goodnight")
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "Should return a boolean true for a valid context array" {
                $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
                $actual | Should Be $true
                $actual | Should BeOfType boolean
            }
        }

    Context "Testing function as per alias (Test-TodoTxtContext)" {}
        It "Should throw an exception for null / empty input" {
            { Test-TodoTxtContext -Project "" } | Should throw "argument is null or empty"
        }

        It "Should return a boolean false for a single invalid context (starting with +)" {
            $actual = Test-TodoTxtContext -Project "+hello"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean false for a single invalid context (containing a space)" {
            $actual = Test-TodoTxtContext -Project "h ello"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean false for a invalid context array" {
            $actual = Test-TodoTxtContext -Project @("so-long", "fairwell", "+auf-Wiedersehen", "goodnight")
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean true for a valid context array" {
            $actual = Test-TodoTxtContext -Project @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
            $actual | Should Be $true
            $actual | Should BeOfType boolean
        }
    }
}