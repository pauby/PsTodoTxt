Import-PTHBuildModule
$functionName = $MyInvocation.MyCommand -split '.tests.ps1'

Describe "Function Testing - $functionName" {
    InModuleScope -ModuleName PsTodoTxt {
        Context "Input" {
            It 'will throw an exception for null or missing parameters' {
                { ConvertFrom-TodoTxt -Todo $null } | Should throw 'argument is null'  # use parameter instead of pipeline otherwise exception not caught
            }
        }

        Context "Logic & Flow" {
            InModuleScope PsTodoTxt {

                Mock Test-TodoTxt { return $false }

                It 'will throw an exception for an invalid object' {
                    { (New-Object -TypeName PSObject -Property @{ 'task' = 'This will fail' }) | ConvertFrom-TodoTxt } | SHould throw 'invalid Todotxt object'
                }
            }
        }

        Context "Output" {

            $tests = @(
                @{  'name'          = 'with DoneDate, CreatedDate and Task';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2019-01-12'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'result'        = 'x 2019-01-12 2016-01-01 Rescue Han from Jabba'
                },
                @{  'name'          = 'with Priority, CreatedDate and Task';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Priority' = 'G'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'result'        = '(G) 2016-01-01 Rescue Han from Jabba'
                },
                @{  'name'          = 'with CreatedDate, Task and Context';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Context' = @('palace', 'jabba'); 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'result'        = '2016-01-01 Rescue Han from Jabba @palace @jabba'
                },
                @{  'name'          = 'with CreatedDate, Task and Addon';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Addon' = [ordered]@{ 'due' = '2017-09-01'; 'help' = 'leia'}; 'CreatedDate' = '2016-01-01';
                        'Task' = 'Rescue Han from Jabba' });
                    'result'        = '2016-01-01 Rescue Han from Jabba due:2017-09-01 help:leia'
                },
                @{  'name'          = 'with everything';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2018-08-15'; Priority = 'K'; 'CreatedDate' = '2016-01-01';
                    'Task' = 'Rescue Han from Jabba'; 'Context' = @('palace', 'jabba'); 'Project' = @('rescue', 'rescue-han'); 'Addon' = [ordered]@{ 'due' = '2087-12-09'; 'help' = 'luke'} });
                    'result'        = 'x 2018-08-15 (K) 2016-01-01 Rescue Han from Jabba @palace @jabba +rescue +rescue-han due:2087-12-09 help:luke'
                }
            )

            It "will return a joined string - <name>" -TestCases $tests {
                Param (
                    $testObject, $result
                )

                ($testObject | ConvertFrom-TodoTxt) | Should Be $result
                ConvertFrom-TodoTxt -Todo $testObject | Should be $result
            }
        } #Context
    }
}