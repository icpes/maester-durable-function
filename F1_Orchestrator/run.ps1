# F1_Orchestrator/run.ps1

param($Context)

Write-Host "[INFO] F1 Orchestrator Started: $($Context.InstanceId)"

try {
    # Get credentials from environment
    $tenantId = $env:TENANT_ID
    $clientId = $env:CLIENT_ID
    $clientSecret = $env:CLIENT_SECRET
    
    # Validate
    if (-not $tenantId -or -not $clientId -or -not $clientSecret) {
        throw "Missing environment variables: TENANT_ID, CLIENT_ID, CLIENT_SECRET"
    }
    
    Write-Host "[INFO] Credentials loaded from environment"
    
    # Define categories to test
    $categories = @("ConditionalAccess", "SecurityDefaults", "IdentityProtection")
    $tasks = @()
    
    Write-Host "[INFO] Fanning out to F2 for: $($categories -join ', ')"
    
    # Schedule F2 activities in parallel
    foreach ($category in $categories) {
        # Pass hashtable directly - Durable Functions will serialize/deserialize automatically
        $activityInput = @{
            category = $category
            tenantId = $tenantId
            clientId = $clientId
            clientSecret = $clientSecret
        }
        
        Write-Host "[INFO]   → Scheduling F2 for: $category"
        $task = Invoke-DurableActivity -FunctionName "F2_MaesterActivity" -Input $activityInput -NoWait
        $tasks += $task
    }
    
    # Wait for all F2 activities to complete
    Write-Host "[INFO] Waiting for $($tasks.Count) parallel F2 tasks..."
    $f2_results = @(Wait-ActivityFunction -Task $tasks)
    
    Write-Host "[INFO] Received $($f2_results.Count) results from F2"
    
    # F2 results are already deserialized hashtables
    foreach ($result in $f2_results) {
        if ($result.status -eq "Success") {
            Write-Host "[INFO]   ✓ $($result.category): $($result.totalTests) tests"
        } else {
            Write-Host "[ERROR]   ✗ $($result.category): $($result.error)"
        }
    }
    
    # Aggregate results with F3
    Write-Host "[INFO] Invoking F3 to aggregate results..."
    $aggregated = Invoke-DurableActivity -FunctionName "F3_ProcessResults" -Input $f2_results
    
    Write-Host "[INFO] Orchestration Complete"
    
    # Return final result
    return @{
        Status = "Completed"
        InstanceId = $Context.InstanceId
        Results = $aggregated
        Timestamp = (Get-Date).ToString("o")
    }
}
catch {
    Write-Host "[ERROR] Orchestration Failed: $_"
    Write-Host "[ERROR] Stack: $($_.ScriptStackTrace)"
    
    return @{
        Status = "Failed"
        Error = $_.Exception.Message
        StackTrace = $_.ScriptStackTrace
        InstanceId = $Context.InstanceId
        Timestamp = (Get-Date).ToString("o")
    }
}