$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here = Split-Path -Parent $here 
Import-Module $here\PsTodoTxt

Describe "Split-TodoTxt" {

    InModuleScope PsTodoTxt {
        Mock Get-TodoTxtTodaysDate { return "2016-05-05" }

        Context "No parameters provided" {
            It "Throws an error" {
                { Split-TodoTxt "" } | Should Throw "null or empty"
            }
        }

        Context "Valid parameters provided to produce a single todo" {
            It "Should return a single hashtable with properties: CreatedDate and Task" {
                $actual = Split-TodoTxt "x 2016-07-07"
                $result = @{ Task = "x 2016-07-07"; CreatedDate = "2016-05-05" }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable
                Compare-Object $actualObj $resultObj -Property DoneDate, Priority, CreatedDate, Task, Context, Project, Addon | Should Be $null
            }

            It "Should return a single hashtable with properties: DoneDate, CreatedDate and Task" {
                $actual = Split-TodoTxt "x 2016-07-07 2015-10-10"
                $result = @{ DoneDate = "2016-07-07"; CreatedDate = "2016-05-05"; Task = "2015-10-10" }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable
                Compare-Object $actualObj $resultObj -Property DoneDate, Priority, CreatedDate, Task, Context, Project, Addon | Should Be $null
            }

            It "Should return a single hashtable with propertioes: DoneDate, Priority, CreatedDate and Task" {
                $actual = Split-TodoTxt "x 2016-07-07 (Y) 2015-10-10"
                $result = @{ DoneDate = "2016-07-07"; Priority = "Y"; CreatedDate = "2016-05-05"; Task = "2015-10-10" }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable
                Compare-Object $actualObj $resultObj -Property DoneDate, Priority, CreatedDate, Task, Context, Project, Addon | Should Be $null
            }

            It "Shoudl return a single hashtable with properties: DoneDate, Priority, CreatedDate, Task, Context, Project and Addon" {
                $actual = Split-TodoTxt "x 2016-07-07 (Y) 2015-10-10 This is a test task @home +window due:2016-12-01"
                $result = @{ DoneDate = "2016-07-07"; Priority = "Y"; CreatedDate = "2015-10-10"; Task = "This is a test task"; Context = @("home");
                    Project = @("window"); Addon = @{ due = "2016-12-01" }; }
                $actualObj = New-Object -TypeName PSObject -Property $actual
                $resultObj = New-Object -TypeName PSObject -Property $result
                $actual | Should BeOfType HashTable  
                Compare-Object $actualObj $resultObj -Property DoneDate, Priority, CreatedDate, Task, Context, Project, Addon | Should Be $null
            }
        }

        Context "Valid parameters provided to produce multiple todos" {
            It "Should return an array of hashtables" {
                $test = @( "x 2016-07-07 (Y) 2015-10-10 This is a test task @home @car +maintenance +window due:2016-12-01",
                            "Another test task @work +career misc:Sometext",
                            "2014-12-31 Merry Christmas +tagme @office" )
                $actual = $test | Split-TodoTxt
                $result = @( @{ DoneDate = "2016-07-07"; Priority = "Y"; CreatedDate = "2015-10-10"; Task = "This is a test task"; Context = @("home", "car");
                    Project = @("maintenance", "window"); Addon = @{ due = "2016-12-01" }; },
                            @{ DoneDate = ""; Priority = ""; CreatedDate="2016-05-05"; Task = "Another test task"; Context = @("work"); Project = @("career"); Addon = @{ misc = "Sometext"} },
                            @{ CreatedDate = "2014-12-31"; Task = "Merry Christmas"; Context = @("office"); Project = @("tagme"); } )
                
                [bool]($actual.Count -eq $result.count) | Should Be $true
                $actual | Should BeOfType HashTable
                
                for ($i = 0; $i -lt $actual.Count; $i++) {
                    $actualObj = New-Object -TypeName PSObject -Property $actual[$i]
                    $resultObj = New-Object -TypeName PSObject -Property $result[$i]
                Compare-Object $actualObj $resultObj -Property CreatedDate, Task, Context, Project, Addon | Should Be $null
                }
            }
        }
    }
}

Remove-Module PsTodoTxt