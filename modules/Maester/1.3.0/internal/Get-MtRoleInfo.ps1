<#
.SYNOPSIS
    Returns the role GUID (template ID) for a given role name.

#>
function Get-MtRoleInfo {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The name of the role to get the GUID (template ID) for.
        [string] $RoleName
    )

    #TODO: Auto generate on each build. Manual process for now is to run the following command and copy the output to the switch statement.
    #Invoke-MtGraphRequest -RelativeUri "directoryRoleTemplates" | select id, displayName | Sort-Object displayName | %{ "`"$($($_.displayName) -replace ' ')`" { '$($_.id)'; break;}"}

    # Also use the below to generate the ValidateSet for this parameter in Get-MtRoleMember whenever this is updated
    #(Invoke-MtGraphRequest -RelativeUri "directoryRoleTemplates" | select id, displayName | Sort-Object displayName | %{ "'$($($_.displayName) -replace ' ')'"}) -join ", "

    switch ($RoleName) {
        'AIAdministrator' { 'd2562ede-74db-457e-a7b6-544e236ebb61'; break; }
        'ApplicationAdministrator' { '9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3'; break; }
        'ApplicationDeveloper' { 'cf1c38e5-3621-4004-a7cb-879624dced7c'; break; }
        'AttackPayloadAuthor' { '9c6df0f2-1e7c-4dc3-b195-66dfbd24aa8f'; break; }
        'AttackSimulationAdministrator' { 'c430b396-e693-46cc-96f3-db01bf8bb62a'; break; }
        'AttributeAssignmentAdministrator' { '58a13ea3-c632-46ae-9ee0-9c0d43cd7f3d'; break; }
        'AttributeAssignmentReader' { 'ffd52fa5-98dc-465c-991d-fc073eb59f8f'; break; }
        'AttributeDefinitionAdministrator' { '8424c6f0-a189-499e-bbd0-26c1753c96d4'; break; }
        'AttributeDefinitionReader' { '1d336d2c-4ae8-42ef-9711-b3604ce3fc2c'; break; }
        'AttributeLogAdministrator' { '5b784334-f94b-471a-a387-e7219fc49ca2'; break; }
        'AttributeLogReader' { '9c99539d-8186-4804-835f-fd51ef9e2dcd'; break; }
        'AttributeProvisioningAdministrator' { 'ecb2c6bf-0ab6-418e-bd87-7986f8d63bbe'; break; }
        'AttributeProvisioningReader' { '422218e4-db15-4ef9-bbe0-8afb41546d79'; break; }
        'AuthenticationAdministrator' { 'c4e39bd9-1100-46d3-8c65-fb160da0071f'; break; }
        'AuthenticationExtensibilityAdministrator' { '25a516ed-2fa0-40ea-a2d0-12923a21473a'; break; }
        'AuthenticationPolicyAdministrator' { '0526716b-113d-4c15-b2c8-68e3c22b9f80'; break; }
        'AzureADJoinedDeviceLocalAdministrator' { '9f06204d-73c1-4d4c-880a-6edb90606fd8'; break; }
        'AzureDevOpsAdministrator' { 'e3973bdf-4987-49ae-837a-ba8e231c7286'; break; }
        'AzureInformationProtectionAdministrator' { '7495fdc4-34c4-4d15-a289-98788ce399fd'; break; }
        'B2CIEFKeysetAdministrator' { 'aaf43236-0c0d-4d5f-883a-6955382ac081'; break; }
        'B2CIEFPolicyAdministrator' { '3edaf663-341e-4475-9f94-5c398ef6c070'; break; }
        'BillingAdministrator' { 'b0f54661-2d74-4c50-afa3-1ec803f12efe'; break; }
        'CloudAppSecurityAdministrator' { '892c5842-a9a6-463a-8041-72aa08ca3cf6'; break; }
        'CloudApplicationAdministrator' { '158c047a-c907-4556-b7ef-446551a6b5f7'; break; }
        'CloudDeviceAdministrator' { '7698a772-787b-4ac8-901f-60d6b08affd2'; break; }
        'ComplianceAdministrator' { '17315797-102d-40b4-93e0-432062caca18'; break; }
        'ComplianceDataAdministrator' { 'e6d1a23a-da11-4be4-9570-befc86d067a7'; break; }
        'ConditionalAccessAdministrator' { 'b1be1c3e-b65d-4f19-8427-f6fa0d97feb9'; break; }
        'CustomerLockBoxAccessApprover' { '5c4f9dcd-47dc-4cf7-8c9a-9e4207cbfc91'; break; }
        'DesktopAnalyticsAdministrator' { '38a96431-2bdf-4b4c-8b6e-5d3d8abac1a4'; break; }
        'DeviceJoin' { '9c094953-4995-41c8-84c8-3ebb9b32c93f'; break; }
        'DeviceManagers' { '2b499bcd-da44-4968-8aec-78e1674fa64d'; break; }
        'DeviceUsers' { 'd405c6df-0af8-4e3b-95e4-4d06e542189e'; break; }
        'DirectoryReaders' { '88d8e3e3-8f55-4a1e-953a-9b9898b8876b'; break; }
        'DirectorySynchronizationAccounts' { 'd29b2b05-8046-44ba-8758-1e26182fcf32'; break; }
        'DirectoryWriters' { '9360feb5-f418-4baa-8175-e2a00bac4301'; break; }
        'DomainNameAdministrator' { '8329153b-31d0-4727-b945-745eb3bc5f31'; break; }
        'Dynamics365Administrator' { '44367163-eba1-44c3-98af-f5787879f96a'; break; }
        'Dynamics365BusinessCentralAdministrator' { '963797fb-eb3b-4cde-8ce3-5878b3f32a3f'; break; }
        'EdgeAdministrator' { '3f1acade-1e04-4fbc-9b69-f0302cd84aef'; break; }
        'ExchangeAdministrator' { '29232cdf-9323-42fd-ade2-1d097af3e4de'; break; }
        'ExchangeRecipientAdministrator' { '31392ffb-586c-42d1-9346-e59415a2cc4e'; break; }
        'ExtendedDirectoryUserAdministrator' { 'dd13091a-6207-4fc0-82ba-3641e056ab95'; break; }
        'ExternalIDUserFlowAdministrator' { '6e591065-9bad-43ed-90f3-e9424366d2f0'; break; }
        'ExternalIDUserFlowAttributeAdministrator' { '0f971eea-41eb-4569-a71e-57bb8a3eff1e'; break; }
        'ExternalIdentityProviderAdministrator' { 'be2f45a1-457d-42af-a067-6ec1fa63bc45'; break; }
        'FabricAdministrator' { 'a9ea8996-122f-4c74-9520-8edcd192826c'; break; }
        'GlobalAdministrator' { '62e90394-69f5-4237-9190-012177145e10'; break; }
        'GlobalReader' { 'f2ef992c-3afb-46b9-b7cf-a126ee74c451'; break; }
        'GlobalSecureAccessAdministrator' { 'ac434307-12b9-4fa1-a708-88bf58caabc1'; break; }
        'GlobalSecureAccessLogReader' { '843318fb-79a6-4168-9e6f-aa9a07481cc4'; break; }
        'GroupsAdministrator' { 'fdd7a751-b60b-444a-984c-02652fe8fa1c'; break; }
        'GuestInviter' { '95e79109-95c0-4d8e-aee3-d01accf2d47b'; break; }
        'GuestUser' { '10dae51f-b6af-4016-8d66-8c2a99b929b3'; break; }
        'HelpdeskAdministrator' { '729827e3-9c14-49f7-bb1b-9608f156bbb8'; break; }
        'HybridIdentityAdministrator' { '8ac3fc64-6eca-42ea-9e69-59f4c7b60eb2'; break; }
        'IdentityGovernanceAdministrator' { '45d8d3c5-c802-45c6-b32a-1d70b5e1e86e'; break; }
        'InsightsAdministrator' { 'eb1f4a8d-243a-41f0-9fbd-c7cdf6c5ef7c'; break; }
        'InsightsAnalyst' { '25df335f-86eb-4119-b717-0ff02de207e9'; break; }
        'InsightsBusinessLeader' { '31e939ad-9672-4796-9c2e-873181342d2d'; break; }
        'IntuneAdministrator' { '3a2c62db-5318-420d-8d74-23affee5d9d5'; break; }
        'IoTDeviceAdministrator' { '2ea5ce4c-b2d8-4668-bd81-3680bd2d227a'; break; }
        'KaizalaAdministrator' { '74ef975b-6605-40af-a5d2-b9539d836353'; break; }
        'KnowledgeAdministrator' { 'b5a8dcf3-09d5-43a9-a639-8e29ef291470'; break; }
        'KnowledgeManager' { '744ec460-397e-42ad-a462-8b3f9747a02c'; break; }
        'LicenseAdministrator' { '4d6ac14f-3453-41d0-bef9-a3e0c569773a'; break; }
        'LifecycleWorkflowsAdministrator' { '59d46f88-662b-457b-bceb-5c3809e5908f'; break; }
        'MessageCenterPrivacyReader' { 'ac16e43d-7b2d-40e0-ac05-243ff356ab5b'; break; }
        'MessageCenterReader' { '790c1fb9-7f7d-4f88-86a1-ef1f95c05c1b'; break; }
        'Microsoft365BackupAdministrator' { '1707125e-0aa2-4d4d-8655-a7c786c76a25'; break; }
        'Microsoft365MigrationAdministrator' { '8c8b803f-96e1-4129-9349-20738d9f9652'; break; }
        'MicrosoftHardwareWarrantyAdministrator' { '1501b917-7653-4ff9-a4b5-203eaf33784f'; break; }
        'MicrosoftHardwareWarrantySpecialist' { '281fe777-fb20-4fbb-b7a3-ccebce5b0d96'; break; }
        'NetworkAdministrator' { 'd37c8bed-0711-4417-ba38-b4abe66ce4c2'; break; }
        'OfficeAppsAdministrator' { '2b745bdf-0803-4d80-aa65-822c4493daac'; break; }
        'OnPremisesDirectorySyncAccount' { 'a92aed5d-d78a-4d16-b381-09adb37eb3b0'; break; }
        'OrganizationalBrandingAdministrator' { '92ed04bf-c94a-4b82-9729-b799a7a4c178'; break; }
        'OrganizationalMessagesApprover' { 'e48398e2-f4bb-4074-8f31-4586725e205b'; break; }
        'OrganizationalMessagesWriter' { '507f53e4-4e52-4077-abd3-d2e1558b6ea2'; break; }
        'PartnerTier1Support' { '4ba39ca4-527c-499a-b93d-d9b492c50246'; break; }
        'PartnerTier2Support' { 'e00e864a-17c5-4a4b-9c06-f5b95a8d5bd8'; break; }
        'PasswordAdministrator' { '966707d0-3269-4727-9be2-8c3a10f19b9d'; break; }
        'PeopleAdministrator' { '024906de-61e5-49c8-8572-40335f1e0e10'; break; }
        'PermissionsManagementAdministrator' { 'af78dc32-cf4d-46f9-ba4e-4428526346b5'; break; }
        'PowerPlatformAdministrator' { '11648597-926c-4cf3-9c36-bcebb0ba8dcc'; break; }
        'PrinterAdministrator' { '644ef478-e28f-4e28-b9dc-3fdde9aa0b1f'; break; }
        'PrinterTechnician' { 'e8cef6f1-e4bd-4ea8-bc07-4b8d950f4477'; break; }
        'PrivilegedAuthenticationAdministrator' { '7be44c8a-adaf-4e2a-84d6-ab2649e08a13'; break; }
        'PrivilegedRoleAdministrator' { 'e8611ab8-c189-46e8-94e1-60213ab1f814'; break; }
        'ReportsReader' { '4a5d8f65-41da-4de4-8968-e035b65339cf'; break; }
        'RestrictedGuestUser' { '2af84b1e-32c8-42b7-82bc-daa82404023b'; break; }
        'SearchAdministrator' { '0964bb5e-9bdb-4d7b-ac29-58e794862a40'; break; }
        'SearchEditor' { '8835291a-918c-4fd7-a9ce-faa49f0cf7d9'; break; }
        'SecurityAdministrator' { '194ae4cb-b126-40b2-bd5b-6091b380977d'; break; }
        'SecurityOperator' { '5f2222b1-57c3-48ba-8ad5-d4759f1fde6f'; break; }
        'SecurityReader' { '5d6b6bb7-de71-4623-b4af-96380a352509'; break; }
        'ServiceSupportAdministrator' { 'f023fd81-a637-4b56-95fd-791ac0226033'; break; }
        'SharePointAdministrator' { 'f28a1f50-f6e7-4571-818b-6a12f2af6b6c'; break; }
        'SharePointEmbeddedAdministrator' { '1a7d78b6-429f-476b-b8eb-35fb715fffd4'; break; }
        'SkypeforBusinessAdministrator' { '75941009-915a-4869-abe7-691bff18279e'; break; }
        'TeamsAdministrator' { '69091246-20e8-4a56-aa4d-066075b2a7a8'; break; }
        'TeamsCommunicationsAdministrator' { 'baf37b3a-610e-45da-9e62-d9d1e5e8914b'; break; }
        'TeamsCommunicationsSupportEngineer' { 'f70938a0-fc10-4177-9e90-2178f8765737'; break; }
        'TeamsCommunicationsSupportSpecialist' { 'fcf91098-03e3-41a9-b5ba-6f0ec8188a12'; break; }
        'TeamsDevicesAdministrator' { '3d762c5a-1b6c-493f-843e-55a3b42923d4'; break; }
        'TeamsTelephonyAdministrator' { 'aa38014f-0993-46e9-9b45-30501a20909d'; break; }
        'TenantCreator' { '112ca1a2-15ad-4102-995e-45b0bc479a6a'; break; }
        'UsageSummaryReportsReader' { '75934031-6c7e-415a-99d7-48dbd49e875e'; break; }
        'User' { 'a0b1b346-4d3e-4e8b-98f8-753987be4970'; break; }
        'UserAdministrator' { 'fe930be7-5e62-47db-91af-98c3a49a38b1'; break; }
        'UserExperienceSuccessManager' { '27460883-1df1-4691-b032-3b79643e5e63'; break; }
        'VirtualVisitsAdministrator' { 'e300d9e7-4a2b-4295-9eff-f1c78b36cc98'; break; }
        'VivaGoalsAdministrator' { '92b086b3-e367-4ef2-b869-1de128fb986e'; break; }
        'VivaPulseAdministrator' { '87761b17-1ed2-4af3-9acd-92a150038160'; break; }
        'Windows365Administrator' { '11451d60-acb2-45eb-a7d6-43d0f0125c13'; break; }
        'WindowsUpdateDeploymentAdministrator' { '32696413-001a-46ae-978c-ce0f6b3620d2'; break; }
        'WorkplaceDeviceJoin' { 'c34f683f-4d5a-4403-affd-6615e00e3a7f'; break; }
        'YammerAdministrator' { '810a2642-a034-447f-a5e8-41beaa378541'; break; }
        default { $null; break }
    }
}

# SIG # Begin signature block
# MIIupwYJKoZIhvcNAQcCoIIumDCCLpQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBTEiReH6/MqKIj
# DiDe4SLg1Ka/2y3DCf8SAk5N+94o06CCE5EwggWQMIIDeKADAgECAhAFmxtXno4h
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
# SIb3DQEJBDEiBCAsw4ws8gUjpEnfPKXHfe12004J7sVgoNBQvbwY7uoUJTANBgkq
# hkiG9w0BAQEFAASCAgBl4UGt0lzU/8vreeNNYWuRuPKileg1JL+jqFi/SA0onA0O
# w+IDoIae6OGZ2LkdkkVCqK7jDoGW8DMyhRQDQ4OLr+z/CachlzQt58PPpg+bdEla
# tn6fCmN+ZFo8/J6Vp5+BoKdQVjVBPqpAt/So4cm/Az5VmXctNpDGX3sE5NtCG7ow
# sDBVca98yH1Xi6XsqS0IDjRLNmX2D9gF9KnbkbDvH1OrkvFRAxgw/ZhB4mTFgTqk
# tqx6C0+28YaNGp40iT/jBswschN0gGIA+6F6Eet0T56EAATW1noQMtR7HgEcvLYV
# bHObCjxh5mMlTjR1iQP8AyH5yqiLRvipWYSHQG+lv/HG0cnozu7/ZyaffurpoeR7
# WjrIhL6fLGiV6LxMy2qZ/9v2QeZwX/Z6enwMZT0VE4xr4CdVVUU7LAr5BRRUiLlJ
# haZlaOUQYg24XG2wx5PxWztqDGPOg4Fkj/9J7RFbHznAGTvx0+9D5nKo42NhSECL
# uKkAFo/PRBroZCfETRmtibkykSnp0mK3IjRjHg8XprYZbCPjqU/1gWPRLjirPB12
# IDRNijgjxba4G4IOZWMUUuBNws3S4MqGl3NI234RGnqOOstXtJ4BS/H3KMv/ICx2
# R92wkJeIlEtJjz2T2adCQBcxpFEH+PGFlTGuZvi6sgPtZDFwD422I58KSXkytqGC
# Fzkwghc1BgorBgEEAYI3AwMBMYIXJTCCFyEGCSqGSIb3DQEHAqCCFxIwghcOAgED
# MQ8wDQYJYIZIAWUDBAIBBQAwdwYLKoZIhvcNAQkQAQSgaARmMGQCAQEGCWCGSAGG
# /WwHATAxMA0GCWCGSAFlAwQCAQUABCC88ua5gJAExHE5irpmVKdPmBa9mRfKmi7N
# 71/y1o/zVAIQWjqJweTZL4I3UAodvp856RgPMjAyNTA2MjMyMzQ0MDNaoIITAzCC
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
# EAEEMBwGCSqGSIb3DQEJBTEPFw0yNTA2MjMyMzQ0MDNaMCsGCyqGSIb3DQEJEAIM
# MRwwGjAYMBYEFNvThe5i29I+e+T2cUhQhyTVhltFMC8GCSqGSIb3DQEJBDEiBCCS
# WuUH6L29OWomKF6QUgrTU+kGb+4V7Snu5Rs2UmULDzA3BgsqhkiG9w0BCRACLzEo
# MCYwJDAiBCB2dp+o8mMvH0MLOiMwrtZWdf7Xc9sF1mW5BZOYQ4+a2zANBgkqhkiG
# 9w0BAQEFAASCAgC4t1t0BXrAvCRaWNgUU4WZZXOk4zNp/bhnxwzJ8Jkv45sjewC7
# 1a8oP1NppFLcIeCfvcgco/hpkQKIYXAQtvKuLahU7ENY+FJ/U6l0qsKBMNyZut4j
# fEqqSrjYVD8+IRMywZyTlElcM5zlZB7WVfke/9EiCNgxmH7svMAWmiMtTAplWWdU
# 6J57FNzx4G4M0msRmkZLh0kj2UmYCmaAClOA9avLbIICm6hTMMSQgMPmFmx+BeQZ
# Za3RvN31PVxVZKcM6s2Fz6QosddnnLljClxcijd1uOPVr6BX4nL+yejNgZGo7Q56
# okdoSbLo6jyRJA8MNLripToHPU1+PgTG59iLmjoWtooxQSCAI+aOXv6Hgk0AZjhA
# nD9rvN7tP8n26iF/HN+4rey7p7WXcaAJ66fd8oMRCVbsKP5vJRbYit711JWaBs7f
# 8YWAr6gT372iFu2Q+v5C9Lu6F0TGS4rfn5m5g0nS0zHzepB9KlgKDMn9nFEnH4qF
# tMfY1mb8mE0bF176tZ1Ur8XesEa9jAhdsfLjFIhmNk39mYltjtXUsqtfwZ4q2E45
# 9HIa0np484Axj3EAGzeMSmXLHXyMU+KY6GGPc6Yw1NW3dV46DwwqwJUxpbsG+J9H
# Y/JWQlLCP7ZVC2di/+JUVQ3XxNZtbqiyFmw6/e6a8tvCaVjkEF+thqbZaw==
# SIG # End signature block
