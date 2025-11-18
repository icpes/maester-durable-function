# F2_MaesterActivity/run.ps1

param($ActivityInput)

Write-Host "[INFO] F2 Activity started"
Write-Host "[INFO] Input Type: $($ActivityInput.GetType().Name)"

try {
    # Get values directly from input (already deserialized by Durable Functions)
    $category = $ActivityInput.category
    $tenantId = $ActivityInput.tenantId
    $clientId = $ActivityInput.clientId
    $clientSecret = $ActivityInput.clientSecret
    
    # Validate inputs
    if (-not $category) { throw "Category is missing" }
    if (-not $tenantId) { throw "TenantId is missing" }
    if (-not $clientId) { throw "ClientId is missing" }
    if (-not $clientSecret) { throw "ClientSecret is missing or empty" }
    
    Write-Host "[INFO] Category: $category"
    Write-Host "[INFO] TenantId: $tenantId"
    
    # Import modules
    Write-Host "[INFO] Importing modules..."
    Import-Module Maester -ErrorAction Stop
    Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
    Import-Module Pester -ErrorAction Stop
    Write-Host "[INFO] Modules imported"
    
    # Connect to Graph
    Write-Host "[INFO] Connecting to Microsoft Graph..."
    $secureSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)
    
    Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $credential -NoWelcome
    Write-Host "[INFO] Connected to tenant"
    
    # Determine test path
    $baseTestPath = "C:\home\site\wwwroot\maester-tests\Maester"
    
    $testSubPath = switch ($category) {
        "ConditionalAccess" { "Entra" }
        "SecurityDefaults" { "Entra" }
        "IdentityProtection" { "Entra" }
        "All" { "Entra" }
        default { "Entra" }
    }
    
    $testPath = Join-Path $baseTestPath $testSubPath
    
    Write-Host "[INFO] Test path: $testPath"
    
    # Verify path exists
    if (-not (Test-Path $testPath)) {
        Write-Host "[ERROR] Test path not found: $testPath"
        Write-Host "[INFO] Checking wwwroot contents..."
        
        $wwwroot = "C:\home\site\wwwroot"
        if (Test-Path $wwwroot) {
            Get-ChildItem $wwwroot -Directory | ForEach-Object { 
                Write-Host "  DIR: $($_.Name)" 
            }
            
            # Check if maester-tests exists
            $maesterTests = Join-Path $wwwroot "maester-tests"
            if (Test-Path $maesterTests) {
                Write-Host "[INFO] maester-tests folder contents:"
                Get-ChildItem $maesterTests -Directory | ForEach-Object {
                    Write-Host "  DIR: $($_.Name)"
                }
            } else {
                Write-Host "[ERROR] maester-tests folder NOT FOUND in wwwroot!"
            }
        }
        
        throw "Test path not found: $testPath"
    }
    
    # Get test files
    $testFiles = @(Get-ChildItem -Path $testPath -Filter "*.Tests.ps1" -ErrorAction SilentlyContinue)
    Write-Host "[INFO] Found $($testFiles.Count) test files"
    
    if ($testFiles.Count -eq 0) {
        Write-Host "[ERROR] No test files in $testPath"
        Write-Host "[INFO] Directory contents:"
        Get-ChildItem -Path $testPath | ForEach-Object {
            Write-Host "  - $($_.Name)"
        }
        throw "No test files found"
    }
    
    # Show sample
    Write-Host "[INFO] Sample tests:"
    $testFiles | Select-Object -First 5 | ForEach-Object {
        Write-Host "  - $($_.Name)"
    }
    
    # Run tests
    Write-Host "[INFO] Running Maester tests..."
    
    $pesterConfig = New-PesterConfiguration
    $pesterConfig.Run.Path = $testPath
    $pesterConfig.Run.PassThru = $true
    $pesterConfig.Output.Verbosity = 'Detailed'

    $pesterConfig.TestRegistry.Enabled = $false
    
    $results = Invoke-Pester -Configuration $pesterConfig
    
    Write-Host "[INFO] Tests completed"
    Write-Host "[INFO]   Total: $($results.TotalCount)"
    Write-Host "[INFO]   Passed: $($results.PassedCount)"
    Write-Host "[INFO]   Failed: $($results.FailedCount)"
    
    # Disconnect
    try { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null } catch {}
    
    # Return result
    return @{
        status = "Success"
        category = $category
        totalTests = $results.TotalCount
        passedTests = $results.PassedCount
        failedTests = $results.FailedCount
        skippedTests = $results.SkippedCount
        duration = [math]::Round($results.Duration.TotalSeconds, 2)
        timestamp = (Get-Date).ToString("o")
    }
}
catch {
    Write-Host "[ERROR] ERROR in F2 Activity: $_"
    Write-Host "[ERROR] Stack Trace: $($_.ScriptStackTrace)"
    
    try { Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null } catch {}
    
    return @{
        status = "Error"
        category = if ($category) { $category } else { "Unknown" }
        error = $_.Exception.Message
        stackTrace = $_.ScriptStackTrace
        errorType   = $_.Exception.GetType().FullName
        timestamp = (Get-Date).ToString("o")
    }
}