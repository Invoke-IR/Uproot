Import-Module -Force $PSScriptRoot\..\WMIEventing.psd1

Remove-WmiEventFilter

Describe 'Get-WmiEventFilter' {

    Context 'no registered filters' {

        It 'should return gracefully' {
            { Get-WmiEventFilter } | Should Not Throw
        }
    }
}

Describe 'Add-WmiEventFilter' {    
    
    Context 'Name and Query parameters specified on the commandline' { 

        It 'should add a local __EventFilters (filter0)' {
            { Add-WmiEventFilter -Name filter0 -Query 'SELECT * FROM Win32_ProcessStartTrace' } | Should Not Throw
        }
    }
}

Add-WmiEventFilter -Name filter1 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter2 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter3 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter4 -Query 'SELECT * FROM Win32_ProcessStartTrace'

Describe 'Get-WmiEventFilter' {    
    
    Context 'five registered filters' { 

        It 'should get all local __EventFilters' {
            $filters = Get-WmiEventFilter 
            $filters.Length | Should Be 5
        }

        It 'should get a local __EventFilter by Name (filter0)' {
            $filter = Get-WmiEventFilter -Name filter0
            $filter.Name | Should Be 'filter0'
        }
    }
}

Describe 'Remove-WmiEventFilter' {    
    
    Context 'five registered filters' { 

        It 'should remove a local filter by Name (filter0)' {
            Remove-WmiEventFilter -Name filter0
            Get-WmiEventFilter -Name filter0 | Should Be $Null
        }

        It 'should remove a local filter by Name through the pipeline (filter1)' {
            Get-WmiEventFilter -Name filter1 | Remove-WmiEventFilter
            Get-WmiEventFilter -Name filter1 | Should Be $Null
        }

        It 'should remove all remaining local __EventFilters' {
            Remove-WmiEventFilter
            Get-WmiEventFilter | Should Be $Null
        }
    }

    Context 'no registered filters' {

        It 'should not fail' {
            { Remove-WmiEventFilter } | Should Not Throw
        }        
    }
}