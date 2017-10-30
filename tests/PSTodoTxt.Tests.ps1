$ModuleName = 'PsTodoTxt'

. "$PSScriptRoot\SharedTestHelper.ps1"

$thisScript = "$PSScriptRoot\..\source\PSTodoTxt.psm1"
Import-TestedModule | Out-Null

Describe "Integration Testing - PSTodoTxt" {

    InModuleScope PsTodoTxt {
        @(
            "2017-10-30 Buy 'How To Build The Death Star' book +book",
            "2015-09-24 Tell Han that Jabba is looking for him @han +smuggling due:2015-09-30",
            "2015-09-29 Get DNA test as I have a funny feeling about Leia +familyties assign:Luke",
            "2015-09-29 Find out if a parsec is a measure of time or distance @computer +millenium-falcon assign:Chewie",
            "2015-09-29 Ask Han if Greedo fired first @han +cantina"
        ) | Add-Content -Path TestDrive:\before.txt -Encoding UTF8
        
        It "exports the same todos that it imports" {
            Import-TodoTxt -Path "TestDrive:\before.txt" | Export-TodoTxt -Path "TestDrive:\after.txt"
            (Get-FileHash -Path "TestDrive:\before.txt").Hash -eq (Get-FileHash -Path "TestDrive:\after.txt").Hash | Should Be $true
        }
    } #InModuleScope

    Context "Code Analysis" {

        It 'passes all PSScriptAnalyser rules' {
                @(Invoke-ScriptAnalyzer -Path $thisScript).count | Should Be 0
        }
    }
}