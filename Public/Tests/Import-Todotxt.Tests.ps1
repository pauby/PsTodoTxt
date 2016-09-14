Describe "Testing Function - $($Function.Name) - Functional Processing" {
    InModuleScope PSTodoTxt {
        Context "Invalid data supplied" {
            It "Should throw an exception for invalid filename" {
                # we need to just generate a filename - GetTempFilename() creates the file too
                $invalidFilename = Join-Path -Path $env:TEMP -ChildPath ((1..25 | ForEach-Object { Get-Random -Min 0 -Max 9 }) -join "") 
                { Import-TodoTxt -Path $invalidFilename  } | Should throw "Cannot validate argument on parameter 'Path'"
            }
        }

        Context "Valid data supplied" {

            $testDate = "2016-05-05"
            Mock Get-TodoTxtTodaysDate { return $testDate }

            It "Should return an empty array for empty todo file" {
                $result = Import-TodoTxt -Path ([System.IO.Path]::GetTempFileName())
                @($result).count | Should Be 0
                $null -eq $result | Should Be $true
            }

            It "Should return a populated array for a populated todo file" {
                $tempPath = ([System.IO.Path]::GetTempFileName())
                $content = @(
                    "2015-07-29 Use the Force Luke",
                    "2015-06-22 It's a piece of JUNK! https://en.wikipedia.org/wiki/Millennium_Falcon @star_wars",
                    "2015-04-12 I am your Father @empire_strikes_back @near_the_end +darthvader",
                    "x 2014-07-30 2016-02-01 Feel the hate @return_of_the_jedi +emperor +darth_vader"
                )
                $output = @(
                        @{ CreatedDate = "2015-07-29"; Task = "Use the Force Luke" },
                        @{ CreatedDate = "2015-06-22"; Task = "It's a piece of JUNK! https://en.wikipedia.org/wiki/Millennium_Falcon"; Context = "star_wars"; },
                        @{ CreatedDate = "2015-04-12"; Task = "I am your Father"; Context = @("empire_strikes_back", "near_the_end"); Project = "darthvader"; },
                        @{ DoneDate = "2014-07-30"; CreatedDate = "2016-02-01"; Task = "Feel the hate"; Context = "return_of_the_jedi"; Project = @( "emperor", "darth_vader"); }
                )
                $content | Set-Content -Path $tempPath
                $actual = Import-Todotxt -Path $tempPath

                $actual.count | Should Be $output.count
                $actual -is [array] | Should be $true
                for ($i = 0; $i -lt $actual.count; $i++) {
                    $expected = New-Object -TypeName PSObject -Property $output[$i]
                    Compare-Object -ReferenceObject $expected -DifferenceObject $actual[$i] -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should be $null
                }
            }
        }
    }
}