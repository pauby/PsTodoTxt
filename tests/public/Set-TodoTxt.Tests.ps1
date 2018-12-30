Import-HelperModuleForTesting

Describe "Function Testing - Set-TodoTxt" {

    Context "Input" {
        Mock -ModuleName PSTodoTxt Test-TodoTxtDate { return $false }
        Mock -ModuleName PSTodoTxt Test-TodoTxtPriority { return $false }
        Mock -ModuleName PSTodoTxt Test-TodoTxtContext { return $false }

        It "will throw an exception for null, empty or missing parameters" {
            { Set-TodoTxt -Todo $null } | Should throw "argument is null"
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -CreatedDate '' } | Should throw "argument is null"
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Task '' } | Should throw "argument is null"
        }

        # remember we are testing that the ValidateScript scriptblock is being executed - we don't care about the results.
        $tests = @(
            @{  'name'      = 'DoneDate';
                'splat'     = @{ 'donedate' = '2016-01-99' };
                'function'  = 'Test-TodoTxtDate'
            },
            @{  'name'      = 'CreatedDate';
                'splat'     = @{ 'createddate' = '2016-01-99' };
                'function'  = 'Test-TodoTxtDate'
            },
            @{  'name'      = 'Priority';
                'splat'     = @{ 'priority' = '1' };
                'function'  = 'Test-TodoTxtPriority'
            },
            @{  'name'      = 'Context';
                'splat'     = @{ 'context' = 'here' };
                'function'  = 'Test-TodoTxtContext'
            },
            @{  'name'      = 'Project';
                'splat'     = @{ 'project' = 'here' };
                'function'  = 'Test-TodoTxtContext'
            }
            )

        It "will throw an exception in ValidateScript statement - <name>" -TestCases $tests {
            Param (
                $splat,
                $function
            )

            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) @splat } | Should throw "did not return a result of True"
            Assert-MockCalled -ModuleName PSTodoTxt -CommandName $function -Times 1
        }

        It 'will pass for empty or $null data for parameters that accept it' {
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -DoneDate ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Priority ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Context ''} | Should not throw
            { Set-TodoTxt -Todo (New-Object -TypeName PSObject) -Project ''} | Should not throw
        }
    } #Context

    Context "Logic & Flow" {
	# Processing and logic flow tests
    }

    Context "Output" {
        $props1 = @{ CreatedDate = "2016-05-05"; DoneDate = "2016-09-09"; Priority = "H";
            Task = "Turn to the Dark Side"; Context = @("deathstar", "hoth");
            Project = @("rebelalliancedestruction", "deathstarbuild"); `
            Addon = @( @{due = "2016-10-01"}, @{ transport = "tie-fighter"} )
            }

        # the same code is used to set any property so we only need to test 1 of removing and 1 of changing

        It 'will pass removing an object property' {
            $objTest = New-Object -TypeName PSObject -Property $props1
            $result = Set-TodoTxt -Todo $objTest -DoneDate ''

            $result | Should BeOfType PSObject
            $result.PSObject.Properties.Name.Count | Should be ($props1.Count - 1)
        }

        It 'will pass modifying a property value' {
            $objTest = New-Object -TypeName PSObject -Property $props1
            $result = Set-TodoTxt -Todo $objTest -Priority 'Z'
            $result.Priority | Should be 'Z'
        }
    } #Context
}