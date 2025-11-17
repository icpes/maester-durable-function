<#
.SYNOPSIS
    Check if any applications or service principals have high risk Graph permissions that can lead to direct or indirect paths
    to Global Admin and full tenant takeover. The permissions are based on the research published at https://github.com/emiliensocchi/azure-tiering/tree/main.

.DESCRIPTION
    Applications that use Graph API permissions with a risk of having a direct or indirect path to Global Admin and full tenant takeover.

.EXAMPLE
    Test-MtHighRiskAppPermissions

    Returns true if no application has Tier-0 graph permissions

.LINK
    https://maester.dev/docs/commands/Test-MtHighRiskAppPermissions
#>
function Test-MtHighRiskAppPermissions {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'This test checks multiple permissions.')]
    [OutputType([bool])]
    param(
        # Check for direct path to Global Admin or indirect path through a combination of permissions. Default is "All".
        [ValidateSet('All', 'Direct', 'Indirect')]
        [String] $AttackPath = "All"
    )

    if (-not (Test-MtConnection Graph)) {
        Add-MtTestResultDetail -SkippedBecause NotConnectedGraph
        return $null
    }

    $allCriticalGraphPermissions = @(
        [pscustomobject]@{
            Id='2f6817f8-7b12-4f0f-bc18-eeaf60705a9e';
            Name='PrivilegedAccess.ReadWrite.AzureADGroup';
            Type='Application';
            Path='Direct'
        }
        [pscustomobject]@{
            Id='32531c59-1f32-461f-b8df-6f8a3b89f73b';
            Name='PrivilegedAccess.ReadWrite.AzureADGroup';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='41202f2c-f7ab-45be-b001-85c9728b9d69';
            Name='PrivilegedAssignmentSchedule.ReadWrite.AzureADGroup';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='06dbc45d-6708-4ef0-a797-f797ee68bf4b';
            Name='PrivilegedAssignmentSchedule.ReadWrite.AzureADGroup';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='dd199f4a-f148-40a4-a2ec-f0069cc799ec';
            Name='RoleAssignmentSchedule.ReadWrite.Directory';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='8c026be3-8e26-4774-9372-8d5d6f21daff';
            Name='RoleAssignmentSchedule.ReadWrite.Directory';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8';
            Name='RoleManagement.ReadWrite.Directory';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='d01b97e9-cbc0-49fe-810a-750afd5527a3';
            Name='RoleManagement.ReadWrite.Directory';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='eccc023d-eccf-4e7b-9683-8813ab36cecc';
            Name='User.DeleteRestore.All';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='4bb440cd-2cf2-4f90-8004-aa2acd2537c5';
            Name='User.DeleteRestore.All';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='3011c876-62b7-4ada-afa2-506cbbecc68c';
            Name='User.EnableDisableAccount.All';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='f92e74e7-2563-467f-9dd0-902688cb5863';
            Name='User.EnableDisableAccount.All';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='50483e42-d915-4231-9639-7fdb7fd190e5';
            Name='UserAuthenticationMethod.ReadWrite.All';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='b7887744-6746-4312-813d-72daeaee7e2d';
            Name='UserAuthenticationMethod.ReadWrite.All';
            Type='Delegated'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='5eb59dd3-1da2-4329-8733-9dabdc435916';
            Name='AdministrativeUnit.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='7b8a2d34-6b3f-4542-a343-54651608ad81';
            Name='AdministrativeUnit.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9';
            Name='Application.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='bdfbf15f-ee85-4955-8675-146e8e5296b5';
            Name='Application.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='18a4783c-866b-4cc7-a460-3d5e5662c884';
            Name='Application.ReadWrite.OwnedBy';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='06b708a9-e830-4db3-a914-8e69da51d44f';
            Name='AppRoleAssignment.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='84bccea3-f856-4a8a-967b-dbe0a3d53a64';
            Name='AppRoleAssignment.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='9241abd9-d0e6-425a-bd4f-47ba86e767a4';
            Name='DeviceManagementConfiguration.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0883f392-0a7a-443d-8c76-16a6d39c7b63';
            Name='DeviceManagementConfiguration.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='e330c4f0-4170-414e-a55a-2f022ec2b57b';
            Name='DeviceManagementRBAC.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0c5e8a55-87a6-4556-93ab-adc52c4d862d';
            Name='DeviceManagementRBAC.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='19dbc75e-c2e2-444c-a770-ec69d8559fc7';
            Name='Directory.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='c5366453-9fb0-48a5-a156-24f0c49a4b84';
            Name='Directory.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='9acd699f-1e81-4958-b001-93b1d2506e19';
            Name='EntitlementManagement.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='ae7a573d-81d7-432b-ad44-4ed5c9d89038';
            Name='EntitlementManagement.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='62a82d76-70ea-41e2-9197-370581804d09';
            Name='Group.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='4e46008b-f24c-477d-8fff-7bb4ec7aafe0';
            Name='Group.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='dbaae8cf-10b5-4b86-a4a1-f871c94c6695';
            Name='GroupMember.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='f81125ac-d3b7-4573-a3b2-7099cc39df9e';
            Name='GroupMember.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='29c18626-4985-4dcd-85c0-193eef327366';
            Name='Policy.ReadWrite.AuthenticationMethod';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='7e823077-d88e-468f-a337-e18f1f0e6c7c';
            Name='Policy.ReadWrite.AuthenticationMethod';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='a402ca1c-2696-4531-972d-6e5ee4aa11ea';
            Name='Policy.ReadWrite.PermissionGrant';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='2672f8bb-fd5e-42e0-85e1-ec764dd2614e';
            Name='Policy.ReadWrite.PermissionGrant';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='618b6020-bca8-4de6-99f6-ef445fa4d857';
            Name='PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='ba974594-d163-484e-ba39-c330d5897667';
            Name='PrivilegedEligibilitySchedule.ReadWrite.AzureADGroup';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='fee28b28-e1f3-4841-818e-2704dc62245f';
            Name='RoleEligibilitySchedule.ReadWrite.Directory';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='62ade113-f8e0-4bf9-a6ba-5acb31db32fd';
            Name='RoleEligibilitySchedule.ReadWrite.Directory';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='b38dcc4d-a239-4ed6-aa84-6c65b284f97c';
            Name='RoleManagementPolicy.ReadWrite.AzureADGroup';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0da165c7-3f15-4236-b733-c0b0f6abe41d';
            Name='RoleManagementPolicy.ReadWrite.AzureADGroup';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='31e08e0a-d3f7-4ca2-ac39-7343fb83e8ad';
            Name='RoleManagementPolicy.ReadWrite.Directory';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='1ff1be21-34eb-448c-9ac9-ce1f506b2a68';
            Name='RoleManagementPolicy.ReadWrite.Directory';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='741f803b-c850-494e-b5df-cde7c675a1ca';
            Name='User.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='204e0828-b5ca-4ad8-b9f3-f32a958e7cc4';
            Name='User.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='cc117bb9-00cf-4eb8-b580-ea2a878fe8f7';
            Name='User-PasswordProfile.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='56760768-b641-451f-8906-e1b8ab31bca7';
            Name='User-PasswordProfile.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='9241abd9-d0e6-425a-bd4f-47ba86e767a4';
            Name='DeviceManagementConfiguration.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0883f392-0a7a-443d-8c76-16a6d39c7b63';
            Name='DeviceManagementConfiguration.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='e330c4f0-4170-414e-a55a-2f022ec2b57b';
            Name='DeviceManagementRBAC.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0c5e8a55-87a6-4556-93ab-adc52c4d862d';
            Name='DeviceManagementRBAC.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='7e05723c-0bb0-42da-be95-ae9f08a6e53c';
            Name='Domain.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='0b5d694c-a244-4bde-86e6-eb5cd07730fe';
            Name='Domain.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='292d869f-3427-49a8-9dab-8c70152b74e9';
            Name='Organization.ReadWrite.All';
            Type='Application'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='46ca0847-7e6b-426e-9775-ea810a948356';
            Name='Organization.ReadWrite.All';
            Type='Delegated'
            Path='Indirect'
        }
        [pscustomobject]@{
            Id='01c0a623-fc9b-48e9-b794-0756f8e8f067';
            Name='Policy.ReadWrite.ConditionalAccess';
            Type='Application'
            Path='Direct'
        }
        [pscustomobject]@{
            Id='ad902697-1014-4ef5-81ef-2b4301988e8c';
            Name='Policy.ReadWrite.ConditionalAccess';
            Type='Delegated'
            Path='Direct'
        }
    )

    $return = $true

    Write-Verbose "Test-MtHighRiskAppPermissions: Checking applications for high-risk permissions"
    try {
        $allApiAssignments = [System.Collections.Generic.List[PSCustomObject]]::new()

        $allServicePrincipals = Invoke-MtGraphRequest -RelativeUri "servicePrincipals"
        foreach ($sp in $allServicePrincipals) {
            If (([string]::IsNullOrEmpty($sp.Id))) {
                Continue
            }
            $spUrl = "https://entra.microsoft.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/$($sp.id)/appId/$($sp.appId)"

            $spAppRoleAssignments = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($sp.Id)/appRoleAssignments" -Method GET
            $spAppRoleAssignments.value | ForEach-Object {
                $allApiAssignments.Add([PSCustomObject]@{
                    appDisplayName = $sp.appDisplayName
                    objectId = $sp.Id
                    appId = $sp.appId
                    appUrl = $spUrl
                    permissionId = $_.appRoleId
                    permissionName = $null
                    type = "Application"
                })
            }

            $spOauth2PermissionGrants = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($sp.Id)/oauth2PermissionGrants" -Method GET
            $spOauth2PermissionGrants.value | ForEach-Object {
                $_.scope.Split(" ") | ForEach-Object {
                    $allApiAssignments.Add([PSCustomObject]@{
                        appDisplayName = $sp.appDisplayName
                        objectId = $sp.Id
                        appId = $sp.appId
                        appUrl = $spUrl
                        permissionId = $null
                        permissionName = $_.Trim()
                        type = "Delegated"
                    })
                }
            }
        }

        if ($attackPath -ne "All") {
            $allCriticalGraphPermissionsToCheck = $allCriticalGraphPermissions | Where-Object { $_.Path -eq $attackPath }
            $attackPathStr = $attackPath.ToLower()
        } else {
            $attackPathStr = "direct or indirect"
            $allCriticalGraphPermissionsToCheck = $allCriticalGraphPermissions
        }

        $allAssignedCriticalPermissions = [System.Collections.Generic.List[PSCustomObject]]::new()
        foreach ($apiAssignment in $allApiAssignments) {
            foreach ($criticalGraphPermission in $allCriticalGraphPermissionsToCheck) {
                $compareAssignmet = if ($apiAssignment.type -eq "Application") { $apiAssignment.permissionId } else { $apiAssignment.permissionName }
                $compareGraphPermission = if ($apiAssignment.type -eq "Application") { $criticalGraphPermission.Id } else { $criticalGraphPermission.Name }

                if (($compareAssignmet -eq $compareGraphPermission) -and ($apiAssignment.type -eq $criticalGraphPermission.Type)) {
                    $allAssignedCriticalPermissions.Add([PSCustomObject]@{
                        ApplicationName = $apiAssignment.appDisplayName
                        ApplicationId = $apiAssignment.appId
                        ApplicationUrl = $apiAssignment.appUrl
                        PermissionName = $criticalGraphPermission.Name
                        PermissionType = $criticalGraphPermission.Type
                        AttackPath = $criticalGraphPermission.Path
                    })
                }
            }
        }
        $return = if (($allAssignedCriticalPermissions | Measure-Object).Count -eq 0) { $true } else { $false }

        if ($return) {
            $testResultMarkdown = "Well done. No application has graph permissions with a risk of having a $($attackPathStr) path to Global Admin and full tenant takeover."
        } else {
            $testResultMarkdown = "At least one application has graph permissions with a risk of having a $($attackPathStr) path to Global Admin and full tenant takeover.`n`n%TestResult%"

            $result = "| ApplicationName | ApplicationId | PermissionName | PermissionType | AttackPath |`n"
            $result += "| --- | --- | --- | --- | --- |`n"
            foreach ($assignedCriticalPermission in $allAssignedCriticalPermissions) {
                $appMdLink = "[$($assignedCriticalPermission.ApplicationName)]($($assignedCriticalPermission.ApplicationUrl))"
                $result += "| $($appMdLink) | $($assignedCriticalPermission.ApplicationId) | $($assignedCriticalPermission.PermissionName) | $($assignedCriticalPermission.PermissionType) | $($assignedCriticalPermission.AttackPath) |`n"
            }
            $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $result
        }
        Add-MtTestResultDetail -Result $testResultMarkdown
    } catch {
        $return = $false
        Write-Error $_.Exception.Message
    }
    return $return
}

# SIG # Begin signature block
# MIIupwYJKoZIhvcNAQcCoIIumDCCLpQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCZ3BjbzKMV2DYT
# +B2BD5q+kA+4s+0SsOp/zuqcXGP5s6CCE5EwggWQMIIDeKADAgECAhAFmxtXno4h
# MuI5B72nd3VcMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNV
# BAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0xMzA4MDExMjAwMDBaFw0z
# ODAxMTUxMjAwMDBaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
# AL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/z
# G6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZ
# anMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7s
# Wxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL
# 2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfb
# BHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3
# JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3c
# AORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqx
# YxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0
# viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aL
# T8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjQjBAMA8GA1Ud
# EwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBTs1+OC0nFdZEzf
# Lmc/57qYrhwPTzANBgkqhkiG9w0BAQwFAAOCAgEAu2HZfalsvhfEkRvDoaIAjeNk
# aA9Wz3eucPn9mkqZucl4XAwMX+TmFClWCzZJXURj4K2clhhmGyMNPXnpbWvWVPjS
# PMFDQK4dUPVS/JA7u5iZaWvHwaeoaKQn3J35J64whbn2Z006Po9ZOSJTROvIXQPK
# 7VB6fWIhCoDIc2bRoAVgX+iltKevqPdtNZx8WorWojiZ83iL9E3SIAveBO6Mm0eB
# cg3AFDLvMFkuruBx8lbkapdvklBtlo1oepqyNhR6BvIkuQkRUNcIsbiJeoQjYUIp
# 5aPNoiBB19GcZNnqJqGLFNdMGbJQQXE9P01wI4YMStyB0swylIQNCAmXHE/A7msg
# dDDS4Dk0EIUhFQEI6FUy3nFJ2SgXUE3mvk3RdazQyvtBuEOlqtPDBURPLDab4vri
# RbgjU2wGb2dVf0a1TD9uKFp5JtKkqGKX0h7i7UqLvBv9R0oN32dmfrJbQdA75PQ7
# 9ARj6e/CVABRoIoqyc54zNXqhwQYs86vSYiv85KZtrPmYQ/ShQDnUBrkG5WdGaG5
# nLGbsQAe79APT0JsyQq87kP6OnGlyE0mpTX9iV28hWIdMtKgK1TtmlfB2/oQzxm3
# i0objwG2J5VT6LaJbVu8aNQj6ItRolb58KaAoNYes7wPD1N1KarqE3fk3oyBIa0H
# EEcRrYc9B9F1vM/zZn4wggawMIIEmKADAgECAhAIrUCyYNKcTJ9ezam9k67ZMA0G
# CSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBaFw0zNjA0MjgyMzU5NTla
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDVtC9C
# 0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc9es0JAfhS0/TeEP0F9ce
# 2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyAVxJrQ5qZ8sU7H/Lvy0da
# E6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQIXhFLqGfLOEYwhrMxe6T
# SXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/sk+FLEikVoQ11vkunKoA
# FdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na59zHh3K3kGKDYwSNHR7Oh
# D26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pgVItJwZPt4bRc4G/rJvmM
# 1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7BzzosmJQayg9Rc9hUZTO1i4F4z
# 8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQokbIYViY9XwCFjyDKK05
# huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jLchApQfDVxW0mdmgRQRNY
# mtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHMIRroOBl8ZhzNeDhFMJlP
# /2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQABo4IBWTCCAVUwEgYDVR0T
# AQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHwYD
# VR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMG
# A1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNV
# HR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeBDAEDMAgGBmeBDAEEATAN
# BgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bgAhql+Eg08yy25nRm95Ry
# sQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7FoFFUP2cvbaF4HZ+N3HL
# IvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZGM1hmYFW9snjdufE5Btf
# Q/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG3RywYFzzDaju4ImhvTnh
# OE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5UbdldAhQfQDN8A+KVssIh
# dXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WIIIJw8MzK7/0pNVwfiThV
# 9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956rEnPLqR0kq3bPKSchh/j
# wVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuWTatEQOON8BUozu3xGFYH
# Ki8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3E+bnKD+sEq6lLyJsQfmC
# XBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60bhQjiWQ1tygVQK+pKHJ6l
# /aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOImYIbqyK+p/pQd52MbOoZW
# eE4wggdFMIIFLaADAgECAhAP1Kd7fuviGgjvj8ZCqpTVMA0GCSqGSIb3DQEBCwUA
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEz
# ODQgMjAyMSBDQTEwHhcNMjUwNDEwMDAwMDAwWhcNMjgwNzA2MjM1OTU5WjBNMQsw
# CQYDVQQGEwJERTEQMA4GA1UEBxMHSGFtYnVyZzEVMBMGA1UEChMMRmFiaWFuIEJh
# ZGVyMRUwEwYDVQQDEwxGYWJpYW4gQmFkZXIwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQCJI0Z1dyHcnutVp/vdHkC2p3oq9xB8JqGYqLRMR/SoBLgI5i+V
# 3AWxu45/ue9MKtlBRlV5d7UAgVoFd9E/aB/aExr0Oj69sPmuI+O2zPozn6UMc9ci
# tp8L2JRHNpN9KWuA06dmUD/VYPRgqmNtGQFW57XaEJ8klHPDxGuigxzudqJveifK
# QjRoRlSileoVhyjlt6tEyorfRgd1VVWFxkso1qVEjn3ucml+DzrA+ZKiDp//C8+N
# TMu9qMecEsXWPk4qhCla7MO1XpDJb8NE/4WY+PYFrwpxSwiBisWlpA8cgf7i7dhI
# 4P9kTMZz8Cl5OB8/DrsZuv0Fxwmmu88b4uo7nI3HwzfnU/wkNO92g8cywdXHgMDp
# IT++srZXnSQG+Pc4TFAQ8dHHBHxabqTSoZpNYQXQySVSvbpavpcAOhgBg4x2gefD
# Y7Y+iEoLXxwFMIQE908pFHj6+iLlmiKHWLt5eSXtwXoJ83XykFlUXTQ9WW+eo9YI
# lB0GZrwq/4g6nx7mWVG3lIcbfF7oDLUt1d7FhqhWHboYTlRMfkVpOz3TCjma9PY3
# R34n7ejn6cF+kkBK6EX3otlmBtb2sXdPModfceLJbfoU0X1la5tExpQjDHbQ8p/5
# HZLFQ0aGe7BDqBKW3HvIQjw81KMUXBToYvODHXiTNlQl1AZHpZCAf/YnKQIDAQAB
# o4ICAzCCAf8wHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYDVR0O
# BBYEFM+bqr/hMxUPyRKDe3JjUSSVDqK/MD4GA1UdIAQ3MDUwMwYGZ4EMAQQBMCkw
# JwYIKwYBBQUHAgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAOBgNVHQ8B
# Af8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwgbUGA1UdHwSBrTCBqjBToFGg
# T4ZNaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0Q29k
# ZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwU6BRoE+GTWh0dHA6Ly9j
# cmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVTaWduaW5nUlNB
# NDA5NlNIQTM4NDIwMjFDQTEuY3JsMIGUBggrBgEFBQcBAQSBhzCBhDAkBggrBgEF
# BQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFwGCCsGAQUFBzAChlBodHRw
# Oi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2ln
# bmluZ1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNydDAJBgNVHRMEAjAAMA0GCSqGSIb3
# DQEBCwUAA4ICAQBKBhy38Rsh6QNW5pFN6JD9MFjRO9NBJGtwVo1J4/DGrtBVQuyV
# wQC9eB1LFgUsKcUWb0hjnS2/J0W3sC9Tt9LHVvhyh+g0Vba+kq3hE284I0C33gaG
# P0Orfepx03oSOX/js0OK3+M5f47bSpeOP4t30ms7STRQKK4KQIAN2MBv3uZ0zO/5
# 695DjB9N1chLPEm82Vn6jtdrq3IJTpPBfksd3V8Ex215LiJLeU2E5EuIfiu/PI22
# M8L4zpXkXlZRUXCfppQA7vjQtzFudl2PqqVVb4+4gyAu/bWRNkVx+D6lAN0hMewh
# PiFwKDoPwO+cycQ5I6IaFEHONcEEANov6XoaCxQoIoXMd3tm3VEl5Wr9yXEEL+hn
# CpcPmGE1d1iloJC0/Uf/TCsf1dSYd2vY4aRdess1GAidk2T27SrkmoHpdvZdYdNA
# ts2doFCTyI6sV2c/jYMpL2NJOYWbhq5AxOuu+DLiw1kDsc/KPmrTuSzBGb7nBuJs
# 0QHR4toabNeYUGyKzMJGeibhy434gfyXXLKOWaik8NceybN4M1kROqHL/+PtB5zf
# Z1me2ygRrKtaP6RJXGvc8EcP5CEdlQOL6tiCg2ARMTYNxnsiLN9mRU9hkzo9BSJ4
# Vm+C6RKABzZj0whAObyqL/PceLKuAqvGoXbhGx8fXhKEgbnSoJ3VsqROFjGCGmww
# ghpoAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0
# MDk2IFNIQTM4NCAyMDIxIENBMQIQD9Sne37r4hoI74/GQqqU1TANBglghkgBZQME
# AgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCAUTkgsjmXMXHa36gBMSsXX+izc9QpQItqTfPaYM5QmlDANBgkq
# hkiG9w0BAQEFAASCAgAGCTHy7OJAobMhA1+0fIOk/fHzMG3dTXRpfvIcnVnVDwsI
# yZGs+BKbm+zw3Xtddr+GUVgTVqTBkLax5f4b4yAbLWVsq974f9AwwlfK7aW6K/rs
# gGbjGrZMfnPLVnIv+f3ymaIiR0cCFhqGH8GZOv3j8QZfGTU6t8L8FmzXhWd3hwsF
# yIO/yvwljzXN3XAzqgxZYBuGYs89B6EKCo+0NIDT10YMM7Ck0W0PAmuEwvd0R5Xb
# TseCov7YQJtljtiy26JI74okkPhYxTB6uUjh6rh86R0KkNTsJRD7l+3WIw+k2c9q
# TR2ejZV62WFUn0Ji7ofb1mjp2OFgSuQ3c+lQPNZLcfgfpFBQx7BknOUda5VcuS+I
# wdDvJ57vLbADPFqr5UhVEB+W/QXTPIlSY5mvyT6B4RWE4WT4pXvW6I0b8FgNsA+F
# I2okyYr3VatBCtZ2PFYIq/VLknZm0AHntjZLECrG0kXgPBTWCUytayBrMNoKq7xK
# IrgpDMgJSNQt5KIlMvVN+fp+5H+I2KOQDSfGbAlsOkf/4qtQ2mIK9RNnvWKq4Dlr
# SuGdxcJ6NPYbaEy5+wE3BkJjrtMV0xFtMcOcttJimAYlMwVmDBI/Q8QfaUMGTNyZ
# 7GEVrc3usFTiWm1ijX3CBjKcuGNZ070N0ZtAtDVU25FZHoiKi2yWOBxgvZwFlaGC
# Fzkwghc1BgorBgEEAYI3AwMBMYIXJTCCFyEGCSqGSIb3DQEHAqCCFxIwghcOAgED
# MQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCGSAGG
# /WwHATAxMA0GCWCGSAFlAwQCAQUABCB9OdIdgyGshjN3oKIYI3fBCZ+e1shmJXjp
# /GtN8q0XqQIQDlC7N+bbyVDOps4UOOeyDRgPMjAyNTA2MjMyMzQ0MzBaoIITAzCC
# BrwwggSkoAMCAQICEAuuZrxaun+Vh8b56QTjMwQwDQYJKoZIhvcNAQELBQAwYzEL
# MAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJE
# aWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBD
# QTAeFw0yNDA5MjYwMDAwMDBaFw0zNTExMjUyMzU5NTlaMEIxCzAJBgNVBAYTAlVT
# MREwDwYDVQQKEwhEaWdpQ2VydDEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0YW1w
# IDIwMjQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC+anOf9pUhq5Yw
# ultt5lmjtej9kR8YxIg7apnjpcH9CjAgQxK+CMR0Rne/i+utMeV5bUlYYSuuM4vQ
# ngvQepVHVzNLO9RDnEXvPghCaft0djvKKO+hDu6ObS7rJcXa/UKvNminKQPTv/1+
# kBPgHGlP28mgmoCw/xi6FG9+Un1h4eN6zh926SxMe6We2r1Z6VFZj75MU/HNmtsg
# tFjKfITLutLWUdAoWle+jYZ49+wxGE1/UXjWfISDmHuI5e/6+NfQrxGFSKx+rDdN
# MsePW6FLrphfYtk/FLihp/feun0eV+pIF496OVh4R1TvjQYpAztJpVIfdNsEvxHo
# fBf1BWkadc+Up0Th8EifkEEWdX4rA/FE1Q0rqViTbLVZIqi6viEk3RIySho1XyHL
# IAOJfXG5PEppc3XYeBH7xa6VTZ3rOHNeiYnY+V4j1XbJ+Z9dI8ZhqcaDHOoj5KGg
# 4YuiYx3eYm33aebsyF6eD9MF5IDbPgjvwmnAalNEeJPvIeoGJXaeBQjIK13SlnzO
# DdLtuThALhGtyconcVuPI8AaiCaiJnfdzUcb3dWnqUnjXkRFwLtsVAxFvGqsxUA2
# Jq/WTjbnNjIUzIs3ITVC6VBKAOlb2u29Vwgfta8b2ypi6n2PzP0nVepsFk8nlcuW
# fyZLzBaZ0MucEdeBiXL+nUOGhCjl+QIDAQABo4IBizCCAYcwDgYDVR0PAQH/BAQD
# AgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8GA1UdIwQYMBaAFLoW2W1NhS9z
# KXaaL3WMaiCPnshvMB0GA1UdDgQWBBSfVywDdw4oFZBmpWNe7k+SH3agWzBaBgNV
# HR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRU
# cnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3JsMIGQBggrBgEF
# BQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
# MFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNl
# cnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3J0MA0GCSqG
# SIb3DQEBCwUAA4ICAQA9rR4fdplb4ziEEkfZQ5H2EdubTggd0ShPz9Pce4FLJl6r
# eNKLkZd5Y/vEIqFWKt4oKcKz7wZmXa5VgW9B76k9NJxUl4JlKwyjUkKhk3aYx7D8
# vi2mpU1tKlY71AYXB8wTLrQeh83pXnWwwsxc1Mt+FWqz57yFq6laICtKjPICYYf/
# qgxACHTvypGHrC8k1TqCeHk6u4I/VBQC9VK7iSpU5wlWjNlHlFFv/M93748YTeoX
# U/fFa9hWJQkuzG2+B7+bMDvmgF8VlJt1qQcl7YFUMYgZU1WM6nyw23vT6QSgwX5P
# q2m0xQ2V6FJHu8z4LXe/371k5QrN9FQBhLLISZi2yemW0P8ZZfx4zvSWzVXpAb9k
# 4Hpvpi6bUe8iK6WonUSV6yPlMwerwJZP/Gtbu3CKldMnn+LmmRTkTXpFIEB06nXZ
# rDwhCGED+8RsWQSIXZpuG4WLFQOhtloDRWGoCwwc6ZpPddOFkM2LlTbMcqFSzm4c
# d0boGhBq7vkqI1uHRz6Fq1IX7TaRQuR+0BGOzISkcqwXu7nMpFu3mgrlgbAW+Bzi
# kRVQ3K2YHcGkiKjA4gi4OA/kz1YCsdhIBHXqBzR0/Zd2QwQ/l4Gxftt/8wY3grcc
# /nS//TVkej9nmUYu83BDtccHHXKibMs/yXHhDXNkoPIdynhVAku7aRZOwqw6pDCC
# Bq4wggSWoAMCAQICEAc2N7ckVHzYR6z9KGYqXlswDQYJKoZIhvcNAQELBQAwYjEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgVHJ1c3RlZCBSb290IEc0
# MB4XDTIyMDMyMzAwMDAwMFoXDTM3MDMyMjIzNTk1OVowYzELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVz
# dGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBAMaGNQZJs8E9cklRVcclA8TykTepl1Gh1tKD
# 0Z5Mom2gsMyD+Vr2EaFEFUJfpIjzaPp985yJC3+dH54PMx9QEwsmc5Zt+FeoAn39
# Q7SE2hHxc7Gz7iuAhIoiGN/r2j3EF3+rGSs+QtxnjupRPfDWVtTnKC3r07G1decf
# BmWNlCnT2exp39mQh0YAe9tEQYncfGpXevA3eZ9drMvohGS0UvJ2R/dhgxndX7RU
# CyFobjchu0CsX7LeSn3O9TkSZ+8OpWNs5KbFHc02DVzV5huowWR0QKfAcsW6Th+x
# tVhNef7Xj3OTrCw54qVI1vCwMROpVymWJy71h6aPTnYVVSZwmCZ/oBpHIEPjQ2OA
# e3VuJyWQmDo4EbP29p7mO1vsgd4iFNmCKseSv6De4z6ic/rnH1pslPJSlRErWHRA
# KKtzQ87fSqEcazjFKfPKqpZzQmiftkaznTqj1QPgv/CiPMpC3BhIfxQ0z9JMq++b
# Pf4OuGQq+nUoJEHtQr8FnGZJUlD0UfM2SU2LINIsVzV5K6jzRWC8I41Y99xh3pP+
# OcD5sjClTNfpmEpYPtMDiP6zj9NeS3YSUZPJjAw7W4oiqMEmCPkUEBIDfV8ju2Tj
# Y+Cm4T72wnSyPx4JduyrXUZ14mCjWAkBKAAOhFTuzuldyF4wEr1GnrXTdrnSDmuZ
# DNIztM2xAgMBAAGjggFdMIIBWTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQW
# BBS6FtltTYUvcyl2mi91jGogj57IbzAfBgNVHSMEGDAWgBTs1+OC0nFdZEzfLmc/
# 57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwgwdwYI
# KwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3JsMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEA
# fVmOwJO2b5ipRCIBfmbW2CFC4bAYLhBNE88wU86/GPvHUF3iSyn7cIoNqilp/GnB
# zx0H6T5gyNgL5Vxb122H+oQgJTQxZ822EpZvxFBMYh0MCIKoFr2pVs8Vc40BIiXO
# lWk/R3f7cnQU1/+rT4osequFzUNf7WC2qk+RZp4snuCKrOX9jLxkJodskr2dfNBw
# CnzvqLx1T7pa96kQsl3p/yhUifDVinF2ZdrM8HKjI/rAJ4JErpknG6skHibBt94q
# 6/aesXmZgaNWhqsKRcnfxI2g55j7+6adcq/Ex8HBanHZxhOACcS2n82HhyS7T6NJ
# uXdmkfFynOlLAlKnN36TU6w7HQhJD5TNOXrd/yVjmScsPT9rp/Fmw0HNT7ZAmyEh
# QNC3EyTN3B14OuSereU0cZLXJmvkOHOrpgFPvT87eK1MrfvElXvtCl8zOYdBeHo4
# 6Zzh3SP9HSjTx/no8Zhf+yvYfvJGnXUsHicsJttvFXseGYs2uJPU5vIXmVnKcPA3
# v5gA3yAWTyf7YGcWoWa63VXAOimGsJigK+2VQbc61RWYMbRiCQ8KvYHZE/6/pNHz
# V9m8BPqC3jLfBInwAM1dwvnQI38AC+R2AibZ8GV2QqYphwlHK+Z/GqSFD/yYlvZV
# VCsfgPrA8g4r5db7qS9EFUrnEw4d2zc4GqEr9u3WfPwwggWNMIIEdaADAgECAhAO
# mxiO+dAt5+/bUOIIQBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUw
# EwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20x
# JDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEw
# MDAwMDBaFw0zMTExMDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxE
# aWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMT
# GERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAL/mkHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprN
# rnsbhA3EMB/zG6Q4FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVy
# r2iTcMKyunWZanMylNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4
# IWGbNOsFxl7sWxq868nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13j
# rclPXuU15zHL2pNe3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4Q
# kXCrVYJBMtfbBHMqbpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQn
# vKFPObURWBf3JFxGj2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu
# 5tTvkpI6nj3cAORFJYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/
# 8tWMcCxBYKqxYxhElRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQp
# JYls5Q5SUUd0viastkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFf
# xCBRa2+xq4aLT8LWRV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGj
# ggE6MIIBNjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/
# 57qYrhwPTzAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8B
# Af8EBAMCAYYweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
# cC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2lj
# ZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6
# oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElE
# Um9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEB
# AHCgv0NcVec4X6CjdBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0a
# FPQTSnovLbc47/T/gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNE
# m0Mh65ZyoUi0mcudT6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZq
# aVSwuKFWjuyk1T3osdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCs
# WKAOQGPFmCLBsln1VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9Fc
# rBjDTZ9ztwGpn1eqXijiuZQxggN2MIIDcgIBATB3MGMxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1c3Rl
# ZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEAuuZrxaun+Vh8b5
# 6QTjMwQwDQYJYIZIAWUDBAIBBQCggdEwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJ
# EAEEMBwGCSqGSIb3DQEJBTEPFw0yNTA2MjMyMzQ0MzBaMCsGCyqGSIb3DQEJEAIM
# MRwwGjAYMBYEFNvThe5i29I+e+T2cUhQhyTVhltFMC8GCSqGSIb3DQEJBDEiBCBm
# WsErmPkDwQcBCmOdVcYN0zHOlQgbcmZyS84ju2qujDA3BgsqhkiG9w0BCRACLzEo
# MCYwJDAiBCB2dp+o8mMvH0MLOiMwrtZWdf7Xc9sF1mW5BZOYQ4+a2zANBgkqhkiG
# 9w0BAQEFAASCAgBi88MwzxHPatmBt7x7Z3h6F9GfohVzl74Ff1u0BvkWVHLrff5o
# hpMygCvxpm3/cjX4TC1jPLWXC1rL//sMCRoljIVgVVfw0RESdRMUmTwIUW5mL6a7
# xhoYQGdlqLHSeiXsNiP1SWV9STX3hx7TsYrBsHOZp3QeQaGp3N0QwIb9sLdrCFsT
# xlL2XFIRJwd28Knfa2v6GfJVsYdBANKZEF2ndzRQu3qx8YfZ6xS6FE0EndHtPbU0
# XZYDdNCB+2feKqZJ39OuQiUdHn60kaMGaSM0Gq4NbxH2k9WW4sWB3RurOHmj8bVq
# 1tl+125POUPMcuGqrVwlHXQ88jXtDd3ItrTZfScUVJ4rH+nIofLnjyJFKozHmhE+
# pKu0DgB5EJrt59WTR/gfX2vV1abZxMPMXOOLz35HXgOhsjoDAw3ERmQHDyrsdLsA
# N0yZpYQmjd8m7HFtoppJKPgdJ0ZFyn8oXy8p/2Hq8PsR3ivtySpk/POvNNRMm0bV
# MgqERYlNVemwj9Ry8M4YDrrrfx2N3VLqQ5YQbuJecSDHT9dWUDcZ76Olr+NabY7C
# 3+X0D59OCfdueZXBUeMIiLR7osQVrzdEvUwagHmXWoSGFxK2hfNqKfM9jNXaUgb+
# iFZ0omB84nPqQ86jri4IvmhNw1iBgD1kjPePKGAbnc5ntkp0za8Jodx8lw==
# SIG # End signature block
