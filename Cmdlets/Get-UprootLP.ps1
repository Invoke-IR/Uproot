function Get-UprootLP
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost'
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
                Write-Output $sc
            }
        }
    }
}