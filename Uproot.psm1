Add-Type -AssemblyName System.Serviceprocess

# Read in all ps1 files in the Cmdlets Directory
$Global:UprootPath = $PSScriptRoot
Get-ChildItem $PSScriptRoot |
    ? {$_.PSIsContainer -and ($_.Name -eq 'Cmdlets')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}