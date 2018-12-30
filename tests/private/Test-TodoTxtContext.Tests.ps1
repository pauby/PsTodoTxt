Import-HelperModuleForTesting

Describe "Testing Function - Test-TodoTxtContext" {
    InModuleScope PsTodoTxt {
        Context "Input" {
            It "Should throw an exception for null / empty input" {
                { Test-TodoTxtContext -Context "" } | Should throw "Cannot validate argument on parameter"
            }
        }

        Context "Output" {
            It "should be true for a single valid context" {
                $actual = Test-TodoTxtContext -Context "hello"
                $actual | Should Be $true
                $actual | Should BeOfType boolean
            }

            It "should be false for a single invalid context (containing a space)" {
                $actual = Test-TodoTxtContext -Context "h ello"
                $actual | Should Be $false
                $actual | Should BeOfType boolean
            }

            It "should be false for a invalid context array" {
                $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "@goodnight")
                $actual | Should Be $true, $true, $true, $false
                $actual | Should BeOfType boolean
            }

            It "should be true for a valid context array" {
                $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
                $actual | Should Be $true, $true, $true, $true
                $actual | Should BeOfType boolean
            }
        } #Context
    } # InModuleScope
}