Import-PTHBuildModule
$functionName = $MyInvocation.MyCommand -split '.tests.ps1'

Describe "Function Testing - $functionName" {
    InModuleScope -ModuleName PsTodoTxt {

        it "should return todays date when no date is passed" {
            $expected = Get-Date -Format 'yyyy-MM-dd'
            ConvertTo-TodoTxtDate | Should -Be $expected
        }

        it "should return a correct formatted date string when a specific date is passed" {
            ConvertTo-TodoTxtDate -Date (Get-Date -Year 1990 -Month 12 -Day 6) | Should -Be '1990-12-06'
        }
    } #InModuleScope
}