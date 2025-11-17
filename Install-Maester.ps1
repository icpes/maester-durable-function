# Install-Maester.ps1
# Script to install Maester and required dependencies

Write-Host "Installing Maester and dependencies..." -ForegroundColor Green

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warning "PowerShell 7+ is recommended for Maester. Current version: $($PSVersionTable.PSVersion)"
}

# Install required modules
$modules = @(
    @{ Name = "Microsoft.Graph.Authentication"; MinVersion = "2.0.0" },
    @{ Name = "Pester"; MinVersion = "5.0.0" },
    @{ Name = "Maester"; MinVersion = "0.0.1" }
)

foreach ($module in $modules) {
    Write-Host "`nChecking $($module.Name)..." -ForegroundColor Yellow
    
    $installed = Get-Module -ListAvailable -Name $module.Name | 
                 Where-Object { $_.Version -ge $module.MinVersion } | 
                 Select-Object -First 1
    
    if ($installed) {
        Write-Host "$($module.Name) is already installed (v$($installed.Version))" -ForegroundColor Green
    } else {
        Write-Host "Installing $($module.Name)..." -ForegroundColor Cyan
        try {
            Install-Module -Name $module.Name -Force -AllowClobber -Scope CurrentUser
            Write-Host "$($module.Name) installed successfully" -ForegroundColor Green
        } catch {
            Write-Error "Failed to install $($module.Name): $_"
        }
    }
}

# Install Azure Functions Core Tools (if not already installed)
Write-Host "`nChecking Azure Functions Core Tools..." -ForegroundColor Yellow
$funcVersion = func --version 2>$null

if ($funcVersion) {
    Write-Host "Azure Functions Core Tools v$funcVersion is installed" -ForegroundColor Green
} else {
    Write-Host "Azure Functions Core Tools not found!" -ForegroundColor Red
    Write-Host "Please install from: https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local" -ForegroundColor Yellow
}

# Test Maester installation
Write-Host "`nTesting Maester installation..." -ForegroundColor Yellow
try {
    Import-Module Maester -ErrorAction Stop
    $maesterVersion = (Get-Module Maester).Version
    Write-Host "Maester v$maesterVersion loaded successfully!" -ForegroundColor Green
} catch {
    Write-Error "Failed to load Maester: $_"
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Register an Azure AD app with required permissions"
Write-Host "2. Update local.settings.json with your credentials"
Write-Host "3. Run: func start"