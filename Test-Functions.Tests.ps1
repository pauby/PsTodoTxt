$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Test-TodoTxtDate" {
    It "Should throw an exception for null / empty input" {
        { Test-TodoTxtDate -Date "" } | Should throw "argument is null or empty"
    }

    It "Should return false for an invalid date" {
        $actual = Test-TodoTxtDate -Date "2917-ss-8j"
        $actual | Should Be $false
        $actual | Should BeOfType boolean
    }

    It "Should return false for a wrongly formatted date" {
        $actual = Test-TodoTxtDate -Date "28-01-1974"
        $actual | Should Be $false
        $actual | Should BeOfType boolean
    }

    It "Should return true for a correctly formatted date" {
        $actual = Test-TodoTxtDate -Date "1974-01-28"
        $actual | Should Be $true
        $actual | Should BeOfType boolean 
    }
}

Describe "Test-TodoTxtPriority" {
    It "Should throw an exception for null / empty input" {
        { Test-TodoTxtPriority -Priority "" } | Should throw "argument is null or empty"
    }

    It "Should return false for invalid priority" {
        $actual = Test-TodoTxtPriority -Priority "9"
        $actual | Should Be $false
        $actual | Should BeOfType boolean
    }

    It "Should return true for uppercase priority" {
        $actual = Test-TodoTxtPriority -Priority "A"
        $actual | Should Be $true
        $actual | Should BeOfType boolean
    }

    It "Should return true for lowercase priority" {
        $actual = Test-TodoTxtPriority -Priority "z"
        $actual | Should Be $true
        $actual | Should BeOfType boolean
    }
}

Describe "Test-TodoTxtContext" {
    It "Should throw an exception for null / empty input" {
        { Test-TodoTxtContext -Context "" } | Should throw "argument is null or empty"
    }

    It "Should return false for a single invalid context (starting with @)" {
        $actual = Test-TodoTxtContext -Context "@hello"
        $actual | Should Be $false
        $actual | Should BeOfType boolean
    }

    It "Should return false for a single invalid context (containing a space)" {
        $actual = Test-TodoTxtContext -Context "h ello"
        $actual | Should Be $false
        $actual | Should BeOfType boolean
    }

    It "Should return false for a invalid context array" {
        $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "@goodnight")
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }

    It "Should return true for a valid context array" {
        $actual = Test-TodoTxtContext -Context @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }
}

Describe "Test-TodoTxtProject" {
    It "Should throw an exception for null / empty input" {
        { Test-TodoTxtProject -Project "" } | Should throw "argument is null or empty"
    }

    It "Should return false for a single invalid context (starting with +)" {
        $actual = Test-TodoTxtProject -Project "+hello"
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }

    It "Should return false for a single invalid context (containing a space)" {
        $actual = Test-TodoTxtProject -Project "h ello"
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }

    It "Should return false for a invalid context array" {
        $actual = Test-TodoTxtProject -Project @("so-long", "fairwell", "+auf-Wiedersehen", "goodnight")
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }

    It "Should return true for a valid context array" {
        $actual = Test-TodoTxtProject -Project @("so-long", "fairwell", "auf-Wiedersehen", "goodnight")
        $actual | Should Be $false
        $actual | Should BeOfType boolean        
    }
}