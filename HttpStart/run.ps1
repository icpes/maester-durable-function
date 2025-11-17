# HttpStart/run.ps1

using namespace System.Net

param($Request, $TriggerMetadata)

$FunctionName = $Request.Params.FunctionName
if (-not $FunctionName) {
    $FunctionName = "F1_Orchestrator"
}

$InputObject = @{
    Tests = @("All")
}

if ($Request.Body -and $Request.Body.Tests) {
    $InputObject.Tests = $Request.Body.Tests
}

$InstanceId = Start-NewOrchestration -FunctionName $FunctionName -Input $InputObject
$Response = New-OrchestrationCheckStatusResponse -Request $Request -InstanceId $InstanceId

Push-OutputBinding -Name Response -Value $Response
