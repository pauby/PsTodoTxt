$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here
Import-Module $here\PsTodoTxt

InModuleScope PsTodoTxt {

    Describe "Test-ObjectProperty" {
        Context "Invalid data provided" {
            It "Should throw an error" {
                { }
            }
        }

Remove-Module PsTodoTxt