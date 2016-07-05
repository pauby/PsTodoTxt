$tests = get-childitem tests\*.tests.ps1 

foreach ($test in $tests) { 
    Invoke-Pester $test.fullname 
}