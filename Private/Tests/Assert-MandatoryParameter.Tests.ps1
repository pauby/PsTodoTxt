Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PsTodoTxt {
        Context "Invalid data provided" {
            It "Should throw an error" {
                { Assert-MandatoryParameter -MandatoryParameter "" -PassedParameter @{} } | Should throw
            }
        }

        Context "Valid data provided" {
            It "Should return `$null" {
                $mandPar = @("Luke")
                $passPar = @{ Luke = "Jedi"; Han = "Pirate" }
                $actual = Assert-MandatoryParameter -MandatoryParameter $mandPar -PassedParameter $passPar
                $expected = $null
                $actual | Should Be $expected
            }

            It "Should return a string with missing parameter" {
                $mandPar = "Luke"
                $passPar = @{ Han = "Pirate" }
                $actual = Assert-MandatoryParameter -MandatoryParameter $mandPar -PassedParameter $passPar
                $expected = $mandPar
                $actual | Should Be $expected
            }

            It "Should return a string[] with missing parameters" {
                $mandPar = @( "Luke", "Han" )
                $passPar = @{ Chewie = "Wookie" }
                $actual = Assert-MandatoryParameter -MandatoryParameter $mandPar -PassedParameter $passPar
                $expected = $mandPar
                $actual | Should Be $expected
            }
        }
    }
}
