function Start-UprootLP
{
    # Add InputObject param!
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $False)]
            [string]$Prefix = "http://*:80/",
        [Parameter(Mandatory = $True, Position = 0)]
            [string]$Server,
        [Parameter(Mandatory = $False)]
            [string]$Port = 514
    )

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            $sc = New-Object System.ServiceProcess.ServiceController('uprootd', $computer)

            if($sc.Status -eq $null)
            {
               Write-Error "Uprootd service does not exist on $($computer). Use the New-UprootLP cmdlet to create the service." -ErrorAction Stop
            }
            else
            {
                # If uprootd is already running, then stop it so we can give it new configs...
                Write-Verbose "The uprootd service on $($computer) is $($sc.Status)."
            
                if($sc.Status -eq "Running")
                {
                    Write-Verbose "The uprootd service on $($computer) has already been started."
                }
                else
                {
                    $sc.Start(@($Prefix, $Server, $Port))
                    Start-Sleep -Milliseconds 50
                    $sc.Refresh()

                    if($sc.Status -ne "Running")
                    {
                        Write-Error "The uprootd service failed to start on $($computer)." -ErrorAction Stop
                    }
                }
            }
        }
    }
}