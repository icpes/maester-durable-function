param($AggregateInput)

Write-Host "[INFO] F3 Aggregation Started"

try {
    # Input is already deserialized - it's an array of results
    $results_array = $AggregateInput
    
    Write-Host "[INFO] Processing $($results_array.Count) result(s)..."
    
    $aggregated = @{
        totalCategories = 0
        totalTests = 0
        totalPassed = 0
        totalFailed = 0
        totalSkipped = 0
        passRate = 0
        complianceStatus = "Unknown"
        categoryResults = @()
        timestamp = (Get-Date).ToString("o")
    }
    
    # Aggregate results
    foreach ($result in $results_array) {
        if ($result.status -eq "Success") {
            $aggregated.totalCategories++
            $aggregated.totalTests += $result.totalTests
            $aggregated.totalPassed += $result.passedTests
            $aggregated.totalFailed += $result.failedTests
            $aggregated.totalSkipped += $result.skippedTests
            
            $aggregated.categoryResults += @{
                category = $result.category
                totalTests = $result.totalTests
                passedTests = $result.passedTests
                failedTests = $result.failedTests
                skippedTests = $result.skippedTests
                duration = $result.duration
            }
            
            Write-Host "[INFO]   ✓ $($result.category): $($result.passedTests)/$($result.totalTests) passed"
        }
        else {
            Write-Host "[ERROR]   ✗ $($result.category): Error - $($result.error)"
            $aggregated.categoryResults += @{
                category = $result.category
                status = "Error"
                error = $result.error
            }
        }
    }
    
    # Calculate pass rate
    if ($aggregated.totalTests -gt 0) {
        $aggregated.passRate = [math]::Round(($aggregated.totalPassed / $aggregated.totalTests) * 100, 2)
        $aggregated.complianceStatus = if ($aggregated.passRate -ge 80) { "Compliant" } else { "Non-Compliant" }
    }
    
    Write-Host ""
    Write-Host "[INFO] ========== RESULTS =========="
    Write-Host "[INFO] Total Tests: $($aggregated.totalTests)"
    Write-Host "[INFO] Passed: $($aggregated.totalPassed)"
    Write-Host "[INFO] Failed: $($aggregated.totalFailed)"
    Write-Host "[INFO] Skipped: $($aggregated.totalSkipped)"
    Write-Host "[INFO] Pass Rate: $($aggregated.passRate)%"
    Write-Host "[INFO] Status: $($aggregated.complianceStatus)"
    Write-Host "[INFO] =============================="
    
    # Return the hashtable directly (Durable Functions will serialize it)
    return $aggregated
}
catch {
    Write-Host "[ERROR] Error in F3: $_"
    Write-Host "[ERROR] Stack: $($_.ScriptStackTrace)"
    
    return @{
        status = "Error"
        error = $_.Exception.Message
        stackTrace = $_.ScriptStackTrace
        timestamp = (Get-Date).ToString("o")
    }
}