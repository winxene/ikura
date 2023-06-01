Set-PoshPrompt -Theme jandedobbeleer
Enable-PoshTransientPrompt
Enable-PoshTooltips
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

