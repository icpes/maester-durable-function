# Maester Durable Functions - Fan-Out/Fan-In Architecture

A serverless solution for running Microsoft 365 security assessments using Maester in an Azure Durable Function with fan-out/fan-in pattern.

## 🎯 Architecture Overview

```
F1 (Orchestrator)
    ↓
    ├─→ F2 (Maester - Conditional Access) ─┐
    ├─→ F2 (Maester - Security Defaults)   ├─→ F3 (Aggregate Results)
    └─→ F2 (Maester - Identity Protection) ┘
```

### Components

- **F1 (Orchestrator)**: Coordinates the workflow, fans out to multiple Maester checks
- **F2 (Maester Activity)**: Runs Maester security tests in parallel (fan-out)
- **F3 (Process Results)**: Aggregates all results from parallel executions (fan-in)

## 🚀 Quick Start

### 1. Prerequisites

Install the following tools:
- **PowerShell 7.4+**: [Download](https://github.com/PowerShell/PowerShell/releases)
- **Azure Functions Core Tools v4**: [Download](https://docs.microsoft.com/azure/azure-functions/functions-run-local)
- **Azurite** (for local storage): `npm install -g azurite`
- **.NET 6 SDK**: [Download](https://dotnet.microsoft.com/download)

### 2. Clone and Setup

```powershell
# Create project directory
mkdir MaesterDurableFunctions
cd MaesterDurableFunctions

# Run setup script
.\setup-script.ps1
```

### 3. Install Maester

```powershell
# Install required PowerShell modules
.\Install-Maester.ps1
```

### 4. Configure Azure AD App

Follow the guide in `Azure-Setup.md` to:
1. Register an Azure AD application
2. Grant required Microsoft Graph permissions
3. Create a client secret

### 5. Configure Local Settings

Update `local.settings.json`:

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "powershell",
    "TENANT_ID": "your-tenant-id",
    "CLIENT_ID": "your-client-id",
    "CLIENT_SECRET": "your-client-secret",
    "MAESTER_OUTPUT_PATH": "./maester-results"
  }
}
```

### 6. Test Locally

```powershell
# Start Azurite (in separate terminal)
azurite

# Start the function app
.\Test-Locally.ps1

# OR manually
func start
```

### 7. Trigger the Orchestration

In a new PowerShell window:

```powershell
# Trigger with default settings
.\Trigger-Test.ps1

# Or specify test categories
.\Trigger-Test.ps1 -Tests @("ConditionalAccess", "SecurityDefaults")
```

## 📁 Project Structure

```
MaesterDurableFunctions/
├── F1_Orchestrator/          # Main orchestration logic
│   ├── run.ps1
│   └── function.json
├── F2_MaesterActivity/       # Maester test execution
│   ├── run.ps1
│   └── function.json
├── F3_ProcessResults/        # Results aggregation
│   ├── run.ps1
│   └── function.json
├── HttpStart/                # HTTP trigger
│   ├── run.ps1
│   └── function.json
├── local.settings.json       # Local configuration
├── host.json                 # Function app settings
├── requirements.psd1         # PowerShell dependencies
├── Install-Maester.ps1       # Setup script
├── Test-Locally.ps1          # Local testing script
├── Trigger-Test.ps1          # Test trigger script
├── Azure-Setup.md            # Azure AD setup guide
├── Deploy-to-Azure.md        # Deployment guide
└── README.md                 # This file
```

## 🔧 Configuration

### Function Settings

Edit `host.json` to customize function behavior:

```json
{
  "version": "2.0",
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
  "functionTimeout": "00:10:00"
}
```

### Maester Test Categories

Supported test categories in F2:
- `ConditionalAccess` - Conditional Access policies
- `SecurityDefaults` - Security defaults configuration
- `IdentityProtection` - Identity protection settings
- `All` - Run all available tests

## 📊 Understanding the Results

### Sample Output

```json
{
  "Status": "Completed",
  "Results": {
    "TotalTests": 45,
    "TotalPassed": 38,
    "TotalFailed": 7,
    "PassRate": 84.44,
    "ComplianceStatus": "Mostly Compliant",
    "CategoryResults": [
      {
        "Category": "ConditionalAccess",
        "PassedTests": 12,
        "FailedTests": 3
      }
    ],
    "Recommendations": [
      "Address 7 failed security tests",
      "Review 3 issues in ConditionalAccess"
    ]
  }
}
```

### Compliance Status Levels

- **Compliant**: 100% pass rate
- **Mostly Compliant**: 80-99% pass rate
- **Partially Compliant**: 50-79% pass rate
- **Non-Compliant**: <50% pass rate

## 🧪 Testing

### Local Testing

```powershell
# Test with all checks
.\Trigger-Test.ps1

# Test specific categories
.\Trigger-Test.ps1 -Tests @("ConditionalAccess")

# Custom function URL
.\Trigger-Test.ps1 -FunctionUrl "http://localhost:7071/api/orchestrators/F1_Orchestrator"
```

### Monitoring Orchestration

The trigger script automatically monitors the orchestration progress and displays results. You can also check status manually:

```powershell
# Get status URL from initial response
$statusUrl = "http://localhost:7071/runtime/webhooks/durabletask/instances/{instanceId}"
Invoke-RestMethod -Uri $statusUrl
```

## 🚢 Deployment to Azure

Follow the detailed guide in `Deploy-to-Azure.md` for:
- Azure CLI deployment
- VS Code deployment
- GitHub Actions CI/CD
- Post-deployment configuration

### Quick Deploy

```powershell
# Login to Azure
az login

# Deploy
$resourceGroup = "rg-maester"
$functionApp = "func-maester-001"

az group create --name $resourceGroup --location eastus

# Create and deploy (see Deploy-to-Azure.md for full steps)
func azure functionapp publish $functionApp
```

## 🔒 Security Considerations

### Required Microsoft Graph Permissions

The Azure AD app requires these **application permissions**:
- `Policy.Read.All`
- `Policy.ReadWrite.ConditionalAccess`
- `Directory.Read.All`
- `User.Read.All`
- `Group.Read.All`
- `RoleManagement.Read.Directory`
- `IdentityRiskyUser.Read.All`
- `SecurityEvents.Read.All`

### Best Practices

1. **Never commit secrets** - Use `.gitignore` for `local.settings.json`
2. **Use Key Vault** - Store secrets in Azure Key Vault for production
3. **Managed Identity** - Use managed identity when deployed to Azure
4. **Least Privilege** - Only grant necessary permissions
5. **Rotate Secrets** - Regularly rotate client secrets

## 📈 Performance Optimization

### Fan-Out Configuration

Adjust parallelism in `host.json`:

```json
{
  "extensions": {
    "durableTask": {
      "maxConcurrentActivityFunctions": 10
    }
  }
}
```

### Execution Time

- **Local**: ~2-5 minutes for all tests
- **Azure Consumption**: ~3-7 minutes (cold start + execution)
- **Azure Premium**: ~1-3 minutes (pre-warmed)

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| "Module not found" | Run `Install-Maester.ps1` |
| "Insufficient privileges" | Grant admin consent for Graph permissions |
| "Storage emulator error" | Start Azurite: `azurite` |
| "Function timeout" | Increase timeout in `host.json` |
| "Authentication failed" | Verify credentials in `local.settings.json` |

### Debug Mode

Enable detailed logging in `host.json`:

```json
{
  "logging": {
    "logLevel": {
      "default": "Debug",
      "Function": "Debug",
      "DurableTask.Core": "Debug"
    }
  }
}
```

## 📚 Additional Resources

- [Maester Documentation](https://maester.dev/)
- [Azure Durable Functions](https://docs.microsoft.com/azure/azure-functions/durable/)
- [PowerShell in Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-reference-powershell)
- [Microsoft Graph Permissions](https://docs.microsoft.com/graph/permissions-reference)

## 🤝 Contributing

This is your project! Customize it to fit your needs:
- Add more test categories
- Implement custom reporting
- Add notification logic
- Schedule recurring assessments

## 📝 License

This project template is provided as-is for your use.

## 💬 Support

For Maester-specific issues, check [Maester GitHub](https://github.com/maester365/maester)

For Azure Functions issues, check [Azure Functions Docs](https://docs.microsoft.com/azure/azure-functions/)

---

**Happy Security Testing! 🔒**