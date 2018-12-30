Import-HelperModuleForTesting

Describe "Function Testing - Test-TodoTxt" {
    InModuleScope PSTodoTxt{
        Context "Input" {

            Mock Test-TodoTxtDate { return $false }
            Mock Test-TodoTxtPriority { return $false }
            Mock Test-TodoTxtContext { return $false }

            $tests = @(
                @{  'name'          = 'missing CreatedDate';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Task' = 'Rescue Han from Jabba' })
                },
                @{  'name'          = 'missing Task';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'CreatedDate' = '2017-01-01'} )
                }
            )

            It 'will return $false for missing parameters - <name>' -TestCases $tests {
                Param (
                    $testObject
                )

                ($testObject | Test-TodoTxt) | Should Be $false
            }

            $tests = @(
                @{  'name'          = 'invalid DoneDate';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2019-01-99'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtDate'
                },
                @{  'name'          = 'invalid Priority';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Priority' = '1'; 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtPriority'
                },
                @{  'name'          = 'invalid Context';
                    'testObject'    = (New-Object -TypeName PSObject -Property @{ 'Context' = @('a b c'); 'CreatedDate' = '2016-01-01'; 'Task' = 'Rescue Han from Jabba' });
                    'mockFunction'  = 'Test-TodoTxtContext'
                }
            )

            It 'will return $false for invalid parameters - <name>' -TestCases $tests {
                Param (
                    $testObject, $mockFunction

                )

                ($testObject | Test-TodoTxt) | Should Be $false
                Assert-MockCalled $mockFunction -Times 1
            }
        }

        Context "Logic & Flow" {
            # as all parameters are validate in the code of the function the tests are below
        }

        Context "Output" {

            Mock Test-TodoTxtDate { return $true }
            Mock Test-TodoTxtPriority { return $true }
            Mock Test-TodoTxtContext { return $true }

            It 'will return valid output' {
                $testObject = (New-Object -TypeName PSObject -Property @{ 'DoneDate' = '2018-08-15'; Priority = 'K'; 'CreatedDate' = '2016-01-01';
                    'Task' = 'Rescue Han from Jabba'; 'Context' = @('palace', 'jabba'); 'Project' = @('rescue', 'rescue-han'); 'Addon' = @{ 'due' = '2087-12-09'; 'help' = 'luke'} });

                ($testObject | Test-TodoTxt) | Should Be $true
            }
        } #Context
    } #InModuleScope
}