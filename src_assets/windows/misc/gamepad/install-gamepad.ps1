param(
    # Install without UI or restart prompts, for silent installs of the host.
    [switch]$Quiet
)

# Check if a compatible version of ViGEmBus is already installed (1.17 or later)
try {
    $vigemBusPath = "$env:SystemRoot\System32\drivers\ViGEmBus.sys"
    $fileVersion = (Get-Item $vigemBusPath).VersionInfo.FileVersion

    if ($fileVersion -ge [System.Version]"1.17") {
        Write-Information "The installed version is 1.17 or later, no update needed. Exiting."
        exit 0
    }
}
catch {
    Write-Information "ViGEmBus driver not found or inaccessible, proceeding with installation."
}

# Install Virtual Gamepad
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$installerPath = Join-Path $scriptPath "vigembus_installer.exe"
$arguments = if ($Quiet) { "/quiet", "/norestart" } else { "/passive", "/promptrestart" }
$process = Start-Process `
    -FilePath $installerPath `
    -ArgumentList $arguments `
    -Wait `
    -PassThru

# 3010 and 1641 mean the driver was installed and Windows needs, or started, a restart.
if ($process.ExitCode -in 0, 3010, 1641) {
    exit 0
}
exit $process.ExitCode
