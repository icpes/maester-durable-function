# Create-AllFiles.ps1 - Creates all necessary files for Maester Durable Function
Write-Host "Creating all project files..." -ForegroundColor Green

# 1. Create host.json
$hostJson = @'
{
  "version": "2.0",
  "managedDependency": {
    "enabled": true
  },
  "extensionBundle": {
    "id": "Microsoft.Azure.Functions.ExtensionBundle",
    "version": "[4.*, 5.0.0)"
  },
  "extensions": {
    "durableTask": {
      "maxConcurrentActivityFunctions": 10,
      "maxConcurrentOrchestratorFunctions": 10
    }
  },
  "functionTimeout": "00:10:00",
  "logging": {
    "logLevel": {
      "default": "Information",
      "Function": "Information"
    }
  }
}
'@
Set-Content -Path "host.json" -Value $hostJson
Write-Host "✓ Created host.json" -ForegroundColor Cyan

# 2. Create requirements.psd1
$requirements = @'
@{
    'Az.Accounts' = '2.*'
    'Microsoft.Graph.Authentication' = '2.*'
    'Pester' = '5.*'
}
'@
Set-Content -Path "requirements.psd1" -Value $requirements
Write-Host "✓ Created requirements.psd1" -ForegroundColor Cyan

# 3. Create local.settings.json
$localSettings = @'
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "powershell",
    "AzureWebJobsFeatureFlags": "EnableWorkerIndexing",
    "TENANT_ID": "PUT_YOUR_TENANT_ID_HERE",
    "CLIENT_ID": "PUT_YOUR_CLIENT_ID_HERE",
    "CLIENT_SECRET": "PUT_YOUR_CLIENT_SECRET_HERE",
    "MAESTER_OUTPUT_PATH": "./maester-results"
  }
}
'@
Set-Content -Path "local.settings.json" -Value $localSettings
Write-Host "✓ Created local.settings.json" -ForegroundColor Cyan

# 4. Create profile.ps1
$profile = @'
# Azure Functions profile.ps1
if ($env:MSI_SECRET) {
    Disable-AzContextAutosave -Scope Process | Out-Null
}
'@
Set-Content -Path "profile.ps1" -Value $profile
Write-Host "✓ Created profile.ps1" -ForegroundColor Cyan

# 5. Create HttpStart function
$httpStartRun = @'
using namespace System.Net

param($Request, $TriggerMetadata)

Write-Host "HTTP trigger received - Starting orchestration"

$FunctionName = "F1_Orchestrator"
$InputObject = @{
    Tests = $Request.Body.Tests ?? @("All")
}

Write-Host "Input: $($InputObject | ConvertTo-Json -Compress)"

$InstanceId = Start-NewOrchestration -FunctionName $FunctionName -Input $InputObject
Write-Host "Started orchestration with ID: $InstanceId"

$Response = New-OrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId
Push-OutputBinding -Name Response -Value $Response
'@
Set-Content -Path "HttpStart/run.ps1" -Value $httpStartRun

$httpStartFunction = @'
{
  "bindings": [
    {
      "authLevel": "anonymous",
      "name": "Request",
      "type": "httpTrigger",
      "direction": "in",
      "route": "orchestrators/{FunctionName}",
      "methods": ["post", "get"]
    },
    {
      "name": "Response",
      "type": "http",
      "direction": "out"
    },
    {
      "name": "starter",
      "type": "orchestrationClient",
      "direction": "in"
    }
  ]
}
'@
Set-Content -Path "HttpStart/function.json" -Value $httpStartFunction
Write-Host "✓ Created HttpStart function" -ForegroundColor Cyan

# 6. Create F1_Orchestrator
$f1Run = @'
param($Context)

Write-Host "Orchestrator started: $($Context.InstanceId)"

try {
    $input = $Context.Input
    
    $maesterConfig = @{
        TenantId = $env:TENANT_ID
        ClientId = $env:CLIENT_ID
        ClientSecret = $env:CLIENT_SECRET
        OutputPath = $env:MAESTER_OUTPUT_PATH ?? "./maester-results"
    }

    Write-Host "Fanning out to Maester activities..."
    
    $parallelTasks = @()
    $testCategories = @(
        @{ Category = "ConditionalAccess"; Config = $maesterConfig },
        @{ Category = "SecurityDefaults"; Config = $maesterConfig },
        @{ Category = "IdentityProtection"; Config = $maesterConfig }
    )
    
    foreach ($testCategory in $testCategories) {
        $task = Invoke-DurableActivity -FunctionName "F2_MaesterActivity" -Input $testCategory
        $parallelTasks += $task
    }
    
    Write-Host "Waiting for all tasks to complete..."
    $maesterResults = Wait-ActivityFunction -Task $parallelTasks
    
    Write-Host "Processing results..."
    $aggregatedResults = Invoke-DurableActivity -FunctionName "F3_ProcessResults" -Input $maesterResults
    
    return @{
        Status = "Completed"
        InstanceId = $Context.InstanceId
        Results = $aggregatedResults
        Timestamp = (Get-Date).ToString("o")
    }
}
catch {
    Write-Error "Orchestration failed: $_"
    return @{
        Status = "Failed"
        Error = $_.Exception.Message
    }
}
'@
Set-Content -Path "F1_Orchestrator/run.ps1" -Value $f1Run

$f1Function = @'
{
  "bindings": [
    {
      "name": "Context",
      "type": "orchestrationTrigger",
      "direction": "in"
    }
  ]
}
'@
Set-Content -Path "F1_Orchestrator/function.json" -Value $f1Function
Write-Host "✓ Created F1_Orchestrator" -ForegroundColor Cyan

# 7. Create F2_MaesterActivity
$f2Run = @'
param($Input)

Write-Host "F2 Activity started for: $($Input.Category)"

try {
    $config = $Input.Config
    $category = $Input.Category
    
    # Simulate Maester test execution
    Write-Host "Running Maester tests for $category..."
    Start-Sleep -Seconds 2
    
    # Mock results (replace with actual Maester execution later)
    $totalTests = Get-Random -Minimum 10 -Maximum 20
    $passedTests = Get-Random -Minimum 5 -Maximum $totalTests
    $failedTests = $totalTests - $passedTests
    
    $summary = @{
        Category = $category
        TotalTests = $totalTests
        PassedTests = $passedTests
        FailedTests = $failedTests
        SkippedTests = 0
        Duration = 2.0
        Timestamp = (Get-Date).ToString("o")
    }
    
    Write-Host "Completed: Passed=$passedTests, Failed=$failedTests"
    
    return @{
        Summary = $summary
        FailedTests = @()
        Status = "Success"
    }
}
catch {
    Write-Error "Error in F2: $_"
    return @{
        Status = "Error"
        Category = $Input.Category
        ErrorMessage = $_.Exception.Message
    }
}
'@
Set-Content -Path "F2_MaesterActivity/run.ps1" -Value $f2Run

$f2Function = @'
{
  "bindings": [
    {
      "name": "Input",
      "type": "activityTrigger",
      "direction": "in"
    }
  ]
}
'@
Set-Content -Path "F2_MaesterActivity/function.json" -Value $f2Function
Write-Host "✓ Created F2_MaesterActivity" -ForegroundColor Cyan

# 8. Create F3_ProcessResults
$f3Run = @'
param($Input)

Write-Host "F3 Processing results..."

try {
    $allResults = $Input
    
    $aggregated = @{
        TotalCategories = $allResults.Count
        TotalTests = 0
        TotalPassed = 0
        TotalFailed = 0
        CategoryResults = @()
        Timestamp = (Get-Date).ToString("o")
    }
    
    foreach ($result in $allResults) {
        if ($result.Status -eq "Success") {
            $summary = $result.Summary
            $aggregated.TotalTests += $summary.TotalTests
            $aggregated.TotalPassed += $summary.PassedTests
            $aggregated.TotalFailed += $summary.FailedTests
            
            $aggregated.CategoryResults += @{
                Category = $summary.Category
                PassedTests = $summary.PassedTests
                FailedTests = $summary.FailedTests
            }
        }
    }
    
    $aggregated.PassRate = if ($aggregated.TotalTests -gt 0) {
        [math]::Round(($aggregated.TotalPassed / $aggregated.TotalTests) * 100, 2)
    } else { 0 }
    
    $aggregated.ComplianceStatus = if ($aggregated.PassRate -ge 80) {
        "Compliant"
    } else {
        "Non-Compliant"
    }
    
    Write-Host "Results: Total=$($aggregated.TotalTests), Passed=$($aggregated.TotalPassed), Failed=$($aggregated.TotalFailed)"
    
    return $aggregated
}
catch {
    Write-Error "Error in F3: $_"
    return @{ Status = "Error"; ErrorMessage = $_.Exception.Message }
}
'@
Set-Content -Path "F3_ProcessResults/run.ps1" -Value $f3Run

$f3Function = @'
{
  "bindings": [
    {
      "name": "Input",
      "type": "activityTrigger",
      "direction": "in"
    }
  ]
}
'@
Set-Content -Path "F3_ProcessResults/function.json" -Value $f3Function
Write-Host "✓ Created F3_ProcessResults" -ForegroundColor Cyan

# 9. Create .gitignore
$gitignore = @'
bin
obj
csx
.vs
edge
Publish

*.user
*.suo
*.cscfg
*.Cache
project.lock.json

/packages
/TestResults

/tools/NuGet.exe
/App_Data
/secrets
/data
.secrets
appsettings.json
local.settings.json

node_modules
dist

.vscode
.env
'@
Set-Content -Path ".gitignore" -Value $gitignore
Write-Host "✓ Created .gitignore" -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "✓ ALL FILES CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nProject structure:" -ForegroundColor Yellow
Get-ChildItem -Recurse -File | Select-Object FullName