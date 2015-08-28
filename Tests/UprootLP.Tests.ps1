Import-Module -Force $PSScriptRoot\..\Uproot.psd1

try
{
    Remove-UprootLP
}
catch
{

}

## Try to Get service before service exists
Describe 'Get-UprootLP' {
    Context 'Service does not exist' {
        It 'should fail' {
             { Get-UprootLP } | Should Throw
        }
    }    
}

## Create Uproot Service
Describe 'New-UprootLP' {  
    Context 'BinaryPath parameter is provided' { 
        It 'should succeed' {
            { New-UprootLP -BinaryPathName $PSScriptRoot\..\bin\uprootd.exe } | Should Not Throw
        }
    }
    Context 'Uprootd service already exists' {
        It 'should fails' {
            { New-UprootLP -BinaryPathName $PSScriptRoot\..\bin\uprootd.exe } | Should Throw
        }
    }
}

Describe 'Get-UprootLP' {  
    Context 'service exists, but is not running' { 
        It 'should return a stopped status' {
            (Get-UprootLP).Status | Should Be 'Stopped'
        }
    }
}

<## Start Service
#Describe 'Start-UprootLP' {
    Context 'service exists, but is not running' { 
        It 'should start the uprootd service' {
            Start-UprootLP -Server 127.0.0.1
            sleep -Milliseconds 50
            (Get-UprootLP).Status | Should Be 'Running'
        }
    }
}

Describe 'Get-UprootLP' {
    Context 'Service exists and is running' { 
        It 'should not error' {
            (Get-UprootLP).Status | Should Be 'Running'
        }
    }
}

## Restart Service
Describe 'Stop-UprootLP' {
    Context 'service exists and is running' {
        It 'should reload the uprootd service with a new config' {
            { Restart-UprootLP -Server 127.0.0.1 } | Should Not Throw
            sleep -Milliseconds 50
            (Get-UprootLP).Status | Should Be 'Running'
        } 
    }
}

## Stop Service
Describe 'Stop-UprootLP' {
    Context 'service exists and is running' {
        It 'should stop the uprootd service' {
            { Stop-UprootLP } | Should Not Throw
            (Get-UprootLP).Status | Should Be 'Stopped'
        } 
    }

    Context 'service exists and is stopped' {
        It 'should fail' {
            { Stop-UprootLP } | Should Not Throw
            (Get-UprootLP).Status | Should Be 'Stopped'
        }
    }
}#>

## Remove Service
Describe 'Remove-UprootLP' {
    Context 'service exists and is stopped' {
        It 'should remove the service cleanly' {
            { Remove-UprootLP } | Should Not Throw
            { Get-UprootLP } | Should Throw
        } 
    }

    Context 'service does not exist' {
        It 'should fail' {
            { Remove-UprootLP } | Should Throw
        }
    }
}
