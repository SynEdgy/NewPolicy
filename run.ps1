[cmdletBinding()]
param()

Write-Warning -Message "Running on $($PSVersionTable.PSVersion)."
import-Module -Name PSDesiredStateConfiguration -PassThru -ErrorAction Stop -Verbose:$false

# Add working dir to PSModulePath if not present
if ($env:PSModulePath.Split([System.io.path]::PathSeparator) -notcontains $PWD.Path)
{
    Write-Verbose -Message "Adding $PWD to PSModulePath."
    $env:PSModulePath = $PWD.Path + [System.io.path]::PathSeparator + $env:PSModulePath
}

# Remove the NewPolicy/unzippedPackage folder & content because Get-DscResource fails otherwise
Write-Verbose -Message "Removing previously built package, if exists."
Remove-Item -Path ./NewPolicy -Force -Recurse -ErrorAction SilentlyContinue -Verbose:$false

# build the MOF and place in MOF folder
Write-Verbose -Message "Compiling the MOF to be used by Guest Config Package."
. ./newpolicy_config.ps1


Import-Module -Name GuestConfiguration -MinimumVersion 3.1.3 -ErrorAction Stop -Verbose:$false

# Package for Guest Config
New-GuestConfigurationPackage -Name NewPolicy -Configuration ./MOF/NewPolicy.mof

#if we're running as admin, we can test the package
if ([Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Test-GuestConfigurationPackage -Verbose -Path './NewPolicy/NewPolicy.zip'
}
else
{
    Write-Warning -Message "Testing the Package will fail if not running elevated. Skipping."
}