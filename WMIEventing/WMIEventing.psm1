# Read in all ps1 files in the Cmdlets Directory
$Global:WMIEventingPath = $PSScriptRoot
Get-ChildItem $PSScriptRoot |
    ? {$_.PSIsContainer -and ($_.Name -eq 'Cmdlets')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}