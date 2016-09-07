#InModuleScope PsTodoTxt {

    Describe "Test-TodoTxtContext" {
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
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }
    }

    Describe "Test-TodoTxtProject" {
        It "Should throw an exception for null / empty input" {
            { Test-TodoTxtProject -Project "" } | Should throw "argument is null or empty"
        }

        It "Should return a boolean false for a single invalid context (starting with +)" {
            $actual = Test-TodoTxtProject -Project "+hello"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean false for a single invalid context (containing a space)" {
            $actual = Test-TodoTxtProject -Project "h ello"
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean false for a invalid context array" {
            $actual = Test-TodoTxtProject -Project @("so-long", "fairwell", "+auf-Wiedersehen", "goodnight")
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }

        It "Should return a boolean true for a valid context array" {
            $actual = Test-TodoTxtProject -Project @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
            $actual | Should Be $false
            $actual | Should BeOfType boolean
        }
    }
#}

Remove-Module PsTodoTxt