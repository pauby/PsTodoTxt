Describe "Testing Function - $($Function.Name) - Functional Processing & Logic" {
    InModuleScope PSTodoTxt {
        Context "Testing Mandatory Parameter - Todo" {
            It "Should throw an exception for null mandatory parameter" {
                { Set-TodoTxt -Todo $null } | Should throw "argument is null"
            }
        }

        Context "Testing Mandatory Parameter - Task" {
            It "Should throw an exception for missing Task parameter" {
                { Set-TodoTxt -Todo (New-Object -Typename PSObject) } | Should throw "Task property"
            }

            It "Should pass for mandatory parameters Todo and Task" {
                $expected = New-Object -Typename PSObject -Property @{ Task = "Test task" }
                $actual = Set-TodoTxt -Todo (New-Object -Typename PSObject) -Task "Test task"
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected -Property Task | Should Be $null
            }
        }

        Context "Valid data supplied" {
            $props1 = @{ CreatedDate = "2016-05-05"; DoneDate = "2016-09-09"; Priority = "H";
                Task = "Turn to the Dark Side"; Context = @("deathstar", "hoth"); 
                Project = @("rebelalliancedestruction", "deathstarbuild"); `
                Addon = @( @{due = "2016-10-01"}, @{ transport = "tie-fighter"} ) }
            $props2 = @{ CreatedDate = "2015-07-08"; DoneDate = "2016-01-01"; Priority = "D";
                Task = "Great, kid. Don't get cocky!"; Context = @("tatooine", "rebel-base"); 
                Project = @("death-star-blow-up"); `
                Addon = @( @{due = "2018-10-19"}, @{ transport = "milenium_falcon"} ) }
            $props3 = @{ CreatedDate = "2012-11-29"; Task = "I'm Luke Skywalker and I'm here to rescue you!"; 
                Context = @("Dagobah", "Mos-Eisley"); 
                Project = @("Yoda", "LearnTheForce"); `
                Addon = @( @{dead = "uncle-owen"}, @{ transport = "x-wing"} ) }

            It "Should return a valid TodoTxt object" {
                $expected = (New-Object -Typename PSObject -Property $props1)
                $actual = (New-Object -Typename PSObject) | Set-TodoTxt -CreatedDate $props1.CreatedDate `
                    -DoneDate $props1.DoneDate -Priority $props1.Priority -Task $props1.Task -Context $props1.Context `
                    -Project $props1.Project -Addon $props1.Addon
                $actual | Should BeOfType Object
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }

            It "Should amend the Task property of multiple existing TodoTxt objects" {
                $expected = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $actual = @( (New-Object -TypeName PSObject -Property $props1), (New-Object -TypeName PSObject -Property $props2),
                    (New-Object -TypeName PSObject -Property $props3) )
                $newTaskText = "Find a new song for the Cantina band"
                $expected | ForEach-Object { 
                    $_.Task = $newTaskText
                }
                $actual = $actual | Set-TodoTxt -Task $newTaskText

                Write-Output -NoEnumerate $actual | Should BeOfType Array
                Compare-Object -ReferenceObject $actual -DifferenceObject $expected `
                    -Property DoneDate, CreatedDate, Priority, Task, Context, Project, Addon | Should Be $null
            }
        }
    }
}