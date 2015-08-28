function Stop-UprootLP
{
    # Add InputObject Param
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost'
    )

    # I want to prompt the user to make sure they are making the right choice
    # I also want a -Force option that doesn't prompt
    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            $sc = New-Object System.ServiceProcess.ServiceController('uprootd', $computer)

            if($sc.Status -eq $null)
            {
               Write-Error "Uprootd service does not exist on $($computer). Use the New-UprootLP cmdlet to create the service."
            }
            else
            {
                # If uprootd is already running, then stop it so we can give it new configs...
                Write-Verbose "The uprootd service on $($computer) is $($sc.Status)"
            
                if($sc.Status -eq "Running")
                {
                    $sc.Stop()
                    Start-Sleep -Milliseconds 25
                    $sc.Refresh()

                    if($sc.Status -eq "Stopped")
                    {
                        Write-Verbose "The uprootd service on $($computer) has been stopped."
                    }  
                    else
                    {
                        Write-Error "Failed to stop the uprootd service on $($computer)"
                    }
                }
            }
        }
    }
}