BeforeDiscovery {
$AuthorizationPolicyAvailable = (Invoke-MtGraphRequest -RelativeUri 'policies/authorizationpolicy' -ApiVersion beta)
$SettingsApiAvailable = (Invoke-MtGraphRequest -RelativeUri 'settings' -ApiVersion beta).values.name
$EntraIDPlan = Get-MtLicenseInformation -Product 'EntraID'
$EnabledAuthMethods = (Get-MtAuthenticationMethodPolicyConfig -State Enabled).Id
$EnabledAdminConsentWorkflow = (Invoke-MtGraphRequest -RelativeUri 'policies/adminConsentRequestPolicy' -ApiVersion beta).isenabled
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP01" {
    It "EIDSCA.AP01: Default Authorization Settings - Enabled Self service password reset for administrators. See https://maester.dev/docs/tests/EIDSCA.AP01" -TestCases @{ AuthorizationPolicyAvailable = $AuthorizationPolicyAvailable } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .allowedToUseSSPR -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AP01 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP04" {
    It "EIDSCA.AP04: Default Authorization Settings - Guest invite restrictions. See https://maester.dev/docs/tests/EIDSCA.AP04" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .allowInvitesFrom -in @('adminsAndGuestInviters','none')
        #>
        Test-MtEidscaControl -CheckId AP04 | Should -BeIn @('adminsAndGuestInviters','none')
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP05" {
    It "EIDSCA.AP05: Default Authorization Settings - Sign-up for email based subscription. See https://maester.dev/docs/tests/EIDSCA.AP05" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .allowedToSignUpEmailBasedSubscriptions -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AP05 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP06" {
    It "EIDSCA.AP06: Default Authorization Settings - User can join the tenant by email validation. See https://maester.dev/docs/tests/EIDSCA.AP06" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .allowEmailVerifiedUsersToJoinOrganization -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AP06 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP07" {
    It "EIDSCA.AP07: Default Authorization Settings - Guest user access. See https://maester.dev/docs/tests/EIDSCA.AP07" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .guestUserRoleId -eq '2af84b1e-32c8-42b7-82bc-daa82404023b'
        #>
        Test-MtEidscaControl -CheckId AP07 | Should -Be '2af84b1e-32c8-42b7-82bc-daa82404023b'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP08" {
    It "EIDSCA.AP08: Default Authorization Settings - User consent policy assigned for applications. See https://maester.dev/docs/tests/EIDSCA.AP08" -TestCases @{ AuthorizationPolicyAvailable = $AuthorizationPolicyAvailable } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .permissionGrantPolicyIdsAssignedToDefaultUserRole -clike 'ManagePermissionGrantsForSelf*' -eq 'ManagePermissionGrantsForSelf.microsoft-user-default-low'
        #>
        Test-MtEidscaControl -CheckId AP08 | Should -Be 'ManagePermissionGrantsForSelf.microsoft-user-default-low'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP09" {
    It "EIDSCA.AP09: Default Authorization Settings - Allow user consent on risk-based apps. See https://maester.dev/docs/tests/EIDSCA.AP09" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .allowUserConsentForRiskyApps -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AP09 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP10" {
    It "EIDSCA.AP10: Default Authorization Settings - Default User Role Permissions - Allowed to create Apps. See https://maester.dev/docs/tests/EIDSCA.AP10" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .defaultUserRolePermissions.allowedToCreateApps -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AP10 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AP14" {
    It "EIDSCA.AP14: Default Authorization Settings - Default User Role Permissions - Allowed to read other users. See https://maester.dev/docs/tests/EIDSCA.AP14" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authorizationPolicy"
            .defaultUserRolePermissions.allowedToReadOtherUsers -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AP14 | Should -Be 'true'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CP01" {
    It "EIDSCA.CP01: Default Settings - Consent Policy Settings - Group owner consent for apps accessing data. See https://maester.dev/docs/tests/EIDSCA.CP01" -TestCases @{ SettingsApiAvailable = $SettingsApiAvailable } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'EnableGroupSpecificConsent' | select-object -expand value -eq 'False'
        #>
        Test-MtEidscaControl -CheckId CP01 | Should -Be 'False'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CP03" {
    It "EIDSCA.CP03: Default Settings - Consent Policy Settings - Block user consent for risky apps. See https://maester.dev/docs/tests/EIDSCA.CP03" {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'BlockUserConsentForRiskyApps' | select-object -expand value -eq 'true'
        #>
        Test-MtEidscaControl -CheckId CP03 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CP04" {
    It "EIDSCA.CP04: Default Settings - Consent Policy Settings - Users can request admin consent to apps they are unable to consent to. See https://maester.dev/docs/tests/EIDSCA.CP04" {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'EnableAdminConsentRequests' | select-object -expand value -eq 'true'
        #>
        Test-MtEidscaControl -CheckId CP04 | Should -Be 'true'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.PR01" {
    It "EIDSCA.PR01: Default Settings - Password Rule Settings - Password Protection - Mode. See https://maester.dev/docs/tests/EIDSCA.PR01" -TestCases @{ EntraIDPlan = $EntraIDPlan } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'BannedPasswordCheckOnPremisesMode' | select-object -expand value -eq 'Enforce'
        #>
        Test-MtEidscaControl -CheckId PR01 | Should -Be 'Enforce'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.PR02" {
    It "EIDSCA.PR02: Default Settings - Password Rule Settings - Password Protection - Enable password protection on Windows Server Active Directory. See https://maester.dev/docs/tests/EIDSCA.PR02" -TestCases @{ EntraIDPlan = $EntraIDPlan } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'EnableBannedPasswordCheckOnPremises' | select-object -expand value -eq 'True'
        #>
        Test-MtEidscaControl -CheckId PR02 | Should -Be 'True'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.PR03" {
    It "EIDSCA.PR03: Default Settings - Password Rule Settings - Enforce custom list. See https://maester.dev/docs/tests/EIDSCA.PR03" -TestCases @{ EntraIDPlan = $EntraIDPlan } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'EnableBannedPasswordCheck' | select-object -expand value -eq 'True'
        #>
        Test-MtEidscaControl -CheckId PR03 | Should -Be 'True'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.PR05" {
    It "EIDSCA.PR05: Default Settings - Password Rule Settings - Smart Lockout - Lockout duration in seconds. See https://maester.dev/docs/tests/EIDSCA.PR05" -TestCases @{ EntraIDPlan = $EntraIDPlan } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'LockoutDurationInSeconds' | select-object -expand value -ge '60'
        #>
        Test-MtEidscaControl -CheckId PR05 | Should -BeGreaterOrEqual '60'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.PR06" {
    It "EIDSCA.PR06: Default Settings - Password Rule Settings - Smart Lockout - Lockout threshold. See https://maester.dev/docs/tests/EIDSCA.PR06" -TestCases @{ EntraIDPlan = $EntraIDPlan } {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'LockoutThreshold' | select-object -expand value -le '10'
        #>
        Test-MtEidscaControl -CheckId PR06 | Should -BeLessOrEqual '10'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.ST08" {
    It "EIDSCA.ST08: Default Settings - Classification and M365 Groups - M365 groups - Allow Guests to become Group Owner. See https://maester.dev/docs/tests/EIDSCA.ST08" {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'AllowGuestsToBeGroupOwner' | select-object -expand value -eq 'false'
        #>
        Test-MtEidscaControl -CheckId ST08 | Should -Be 'false'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.ST09" {
    It "EIDSCA.ST09: Default Settings - Classification and M365 Groups - M365 groups - Allow Guests to have access to groups content. See https://maester.dev/docs/tests/EIDSCA.ST09" {
        <#
            Check if "https://graph.microsoft.com/beta/settings"
            .values | where-object name -eq 'AllowGuestsToAccessGroups' | select-object -expand value -eq 'True'
        #>
        Test-MtEidscaControl -CheckId ST09 | Should -Be 'True'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AG01" {
    It "EIDSCA.AG01: Authentication Method - General Settings - Manage migration. See https://maester.dev/docs/tests/EIDSCA.AG01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy"
            .policyMigrationState -in @('migrationComplete', '')
        #>
        Test-MtEidscaControl -CheckId AG01 | Should -BeIn @('migrationComplete', '')
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AG02" {
    It "EIDSCA.AG02: Authentication Method - General Settings - Report suspicious activity - State. See https://maester.dev/docs/tests/EIDSCA.AG02" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy"
            .reportSuspiciousActivitySettings.state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AG02 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AG03" {
    It "EIDSCA.AG03: Authentication Method - General Settings - Report suspicious activity - Included users/groups. See https://maester.dev/docs/tests/EIDSCA.AG03" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy"
            .reportSuspiciousActivitySettings.includeTarget.id -eq 'all_users'
        #>
        Test-MtEidscaControl -CheckId AG03 | Should -Be 'all_users'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM01" {
    It "EIDSCA.AM01: Authentication Method - Microsoft Authenticator - State. See https://maester.dev/docs/tests/EIDSCA.AM01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AM01 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM02" {
    It "EIDSCA.AM02: Authentication Method - Microsoft Authenticator - Allow use of Microsoft Authenticator OTP. See https://maester.dev/docs/tests/EIDSCA.AM02" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .isSoftwareOathEnabled -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AM02 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM03" {
    It "EIDSCA.AM03: Authentication Method - Microsoft Authenticator - Require number matching for push notifications. See https://maester.dev/docs/tests/EIDSCA.AM03" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.numberMatchingRequiredState.state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AM03 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM04" {
    It "EIDSCA.AM04: Authentication Method - Microsoft Authenticator - Included users/groups of number matching for push notifications. See https://maester.dev/docs/tests/EIDSCA.AM04" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.numberMatchingRequiredState.includeTarget.id -eq 'all_users'
        #>
        Test-MtEidscaControl -CheckId AM04 | Should -Be 'all_users'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM06" {
    It "EIDSCA.AM06: Authentication Method - Microsoft Authenticator - Show application name in push and passwordless notifications. See https://maester.dev/docs/tests/EIDSCA.AM06" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.displayAppInformationRequiredState.state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AM06 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM07" {
    It "EIDSCA.AM07: Authentication Method - Microsoft Authenticator - Included users/groups to show application name in push and passwordless notifications. See https://maester.dev/docs/tests/EIDSCA.AM07" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.displayAppInformationRequiredState.includeTarget.id -eq 'all_users'
        #>
        Test-MtEidscaControl -CheckId AM07 | Should -Be 'all_users'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM09" {
    It "EIDSCA.AM09: Authentication Method - Microsoft Authenticator - Show geographic location in push and passwordless notifications. See https://maester.dev/docs/tests/EIDSCA.AM09" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.displayLocationInformationRequiredState.state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AM09 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AM10" {
    It "EIDSCA.AM10: Authentication Method - Microsoft Authenticator - Included users/groups to show geographic location in push and passwordless notifications. See https://maester.dev/docs/tests/EIDSCA.AM10" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('MicrosoftAuthenticator')"
            .featureSettings.displayLocationInformationRequiredState.includeTarget.id -eq 'all_users'
        #>
        Test-MtEidscaControl -CheckId AM10 | Should -Be 'all_users'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF01" {
    It "EIDSCA.AF01: Authentication Method - FIDO2 security key - State. See https://maester.dev/docs/tests/EIDSCA.AF01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AF01 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF02" {
    It "EIDSCA.AF02: Authentication Method - FIDO2 security key - Allow self-service set up. See https://maester.dev/docs/tests/EIDSCA.AF02" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .isSelfServiceRegistrationAllowed -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AF02 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF03" {
    It "EIDSCA.AF03: Authentication Method - FIDO2 security key - Enforce attestation. See https://maester.dev/docs/tests/EIDSCA.AF03" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .isAttestationEnforced -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AF03 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF04" {
    It "EIDSCA.AF04: Authentication Method - FIDO2 security key - Enforce key restrictions. See https://maester.dev/docs/tests/EIDSCA.AF04" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .keyRestrictions.isEnforced -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AF04 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF05" {
    It "EIDSCA.AF05: Authentication Method - FIDO2 security key - Restricted. See https://maester.dev/docs/tests/EIDSCA.AF05" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .keyRestrictions.aaGuids -notcontains $null -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AF05 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AF06" {
    It "EIDSCA.AF06: Authentication Method - FIDO2 security key - Restrict specific keys. See https://maester.dev/docs/tests/EIDSCA.AF06" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Fido2')"
            .keyRestrictions.aaGuids -notcontains $null -and ($result.keyRestrictions.enforcementType -eq 'allow' -or $result.keyRestrictions.enforcementType -eq 'block') -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AF06 | Should -Be 'true'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AT01" {
    It "EIDSCA.AT01: Authentication Method - Temporary Access Pass - State. See https://maester.dev/docs/tests/EIDSCA.AT01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('TemporaryAccessPass')"
            .state -eq 'enabled'
        #>
        Test-MtEidscaControl -CheckId AT01 | Should -Be 'enabled'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AT02" {
    It "EIDSCA.AT02: Authentication Method - Temporary Access Pass - One-time. See https://maester.dev/docs/tests/EIDSCA.AT02" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('TemporaryAccessPass')"
            .isUsableOnce -eq 'true'
        #>
        Test-MtEidscaControl -CheckId AT02 | Should -Be 'true'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AV01" {
    It "EIDSCA.AV01: Authentication Method - Voice call - State. See https://maester.dev/docs/tests/EIDSCA.AV01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Voice')"
            .state -eq 'disabled'
        #>
        Test-MtEidscaControl -CheckId AV01 | Should -Be 'disabled'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.AS04" {
    It "EIDSCA.AS04: Authentication Method - SMS - Use for sign-in. See https://maester.dev/docs/tests/EIDSCA.AS04" -TestCases @{ EnabledAuthMethods = $EnabledAuthMethods } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations('Sms')"
            .includeTargets.isUsableForSignIn -eq 'false'
        #>
        Test-MtEidscaControl -CheckId AS04 | Should -Be 'false'
    }
}

Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CR01" {
    It "EIDSCA.CR01: Consent Framework - Admin Consent Request - Policy to enable or disable admin consent request feature. See https://maester.dev/docs/tests/EIDSCA.CR01" {
        <#
            Check if "https://graph.microsoft.com/beta/policies/adminConsentRequestPolicy"
            .isEnabled -eq 'true'
        #>
        Test-MtEidscaControl -CheckId CR01 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CR02" {
    It "EIDSCA.CR02: Consent Framework - Admin Consent Request - Reviewers will receive email notifications for requests. See https://maester.dev/docs/tests/EIDSCA.CR02" -TestCases @{ EnabledAdminConsentWorkflow = $EnabledAdminConsentWorkflow } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/adminConsentRequestPolicy"
            .notifyReviewers -eq 'true'
        #>
        Test-MtEidscaControl -CheckId CR02 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CR03" {
    It "EIDSCA.CR03: Consent Framework - Admin Consent Request - Reviewers will receive email notifications when admin consent requests are about to expire. See https://maester.dev/docs/tests/EIDSCA.CR03" -TestCases @{ EnabledAdminConsentWorkflow = $EnabledAdminConsentWorkflow } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/adminConsentRequestPolicy"
            .remindersEnabled -eq 'true'
        #>
        Test-MtEidscaControl -CheckId CR03 | Should -Be 'true'
    }
}
Describe "EIDSCA" -Tag "EIDSCA", "Security", "All", "EIDSCA.CR04" {
    It "EIDSCA.CR04: Consent Framework - Admin Consent Request - Consent request duration (days). See https://maester.dev/docs/tests/EIDSCA.CR04" -TestCases @{ EnabledAdminConsentWorkflow = $EnabledAdminConsentWorkflow } {
        <#
            Check if "https://graph.microsoft.com/beta/policies/adminConsentRequestPolicy"
            .requestDurationInDays -le '30'
        #>
        Test-MtEidscaControl -CheckId CR04 | Should -BeLessOrEqual '30'
    }
}



# SIG # Begin signature block
# MIIuqAYJKoZIhvcNAQcCoIIumTCCLpUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA8iQiEmvb0Gtt6
# S7wtXZ97zlwgLmKPEQEpN1qN3NolkqCCE5EwggWQMIIDeKADAgECAhAFmxtXno4h
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
# Vm+C6RKABzZj0whAObyqL/PceLKuAqvGoXbhGx8fXhKEgbnSoJ3VsqROFjGCGm0w
# ghppAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0
# MDk2IFNIQTM4NCAyMDIxIENBMQIQD9Sne37r4hoI74/GQqqU1TANBglghkgBZQME
# AgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEM
# BgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC8GCSqG
# SIb3DQEJBDEiBCA1HNB+C42dt6X7z5h2eYG0LIsBKiVfCTwJED3nVcHpMTANBgkq
# hkiG9w0BAQEFAASCAgBU0iUGKMdAEA2seViUnbH5f3V3FHJTX20gTxuT9ZvzGOVW
# p1cvao9SOaAJ+3QRo/iJ4j6XbJ57mRCCsBMg4lYylIUzjoDyAEdWxGoAIVgVUujh
# IKsIbtM/r1NY7UepR4q0sqXsmc3VcgeRjHT+EVLyxuq2n9aE2pMQvR+ZhPrTHYV7
# JD57Aj7TmmV1kJLBbJrvOwsxWhzxbUJZ1BBIO8jfO3ggyKdx26gdpCA0QH+wlis3
# qybEqUOVU5ZvTrQ2+UnR3IQiTGwAk7HWqkYkgYfdAhGOAEtCyZ5L5AGAfHYVDbQH
# C5zXGizcka8xu1TEgWmQGKD4VM88EBWJTUmkqeidl9SsB9DnZYxHnhJdjR/mshrI
# 5PWEG+88rYrOvpnpmA2dnWDTWHWyuvojejxFaM084zBIY/SwyfCvL3HZsSOurT41
# rXOiPGLEbg3PpYP4yemRTaibMR7EwlHrhr1nMTUcdxASmif237OgbTFhkk7PSKGz
# 4KceJmt05WPMF7O4Qx3U9rgEbOkuwlTFGnzXja95FK9YbH99b5DPYFbMdkdYklX5
# IhcJRgWfxsHNLwZKfVGM643aFFd/g6sZeWKfCXjoE8DYKe0Zn2L+U37s9PCOuIGe
# VxR0E631AGXRgan7p0JMT3L4jl9//iLvCXMVNG36gmhmkFfNk7l6/Y4SWiRhyaGC
# Fzowghc2BgorBgEEAYI3AwMBMYIXJjCCFyIGCSqGSIb3DQEHAqCCFxMwghcPAgED
# MQ8wDQYJYIZIAWUDBAIBBQAweAYLKoZIhvcNAQkQAQSgaQRnMGUCAQEGCWCGSAGG
# /WwHATAxMA0GCWCGSAFlAwQCAQUABCA7JUJ0WNo9/ClAsxqtnh+iMt4xujE5Dq9+
# NDs47OjbSAIRAK/NmMh2HVRoXrZjcntZ61cYDzIwMjUwNjIzMjM0NDE4WqCCEwMw
# gga8MIIEpKADAgECAhALrma8Wrp/lYfG+ekE4zMEMA0GCSqGSIb3DQEBCwUAMGMx
# CzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMy
# RGlnaUNlcnQgVHJ1c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcg
# Q0EwHhcNMjQwOTI2MDAwMDAwWhcNMzUxMTI1MjM1OTU5WjBCMQswCQYDVQQGEwJV
# UzERMA8GA1UEChMIRGlnaUNlcnQxIDAeBgNVBAMTF0RpZ2lDZXJ0IFRpbWVzdGFt
# cCAyMDI0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvmpzn/aVIauW
# MLpbbeZZo7Xo/ZEfGMSIO2qZ46XB/QowIEMSvgjEdEZ3v4vrrTHleW1JWGErrjOL
# 0J4L0HqVR1czSzvUQ5xF7z4IQmn7dHY7yijvoQ7ujm0u6yXF2v1CrzZopykD07/9
# fpAT4BxpT9vJoJqAsP8YuhRvflJ9YeHjes4fduksTHulntq9WelRWY++TFPxzZrb
# ILRYynyEy7rS1lHQKFpXvo2GePfsMRhNf1F41nyEg5h7iOXv+vjX0K8RhUisfqw3
# TTLHj1uhS66YX2LZPxS4oaf33rp9HlfqSBePejlYeEdU740GKQM7SaVSH3TbBL8R
# 6HwX9QVpGnXPlKdE4fBIn5BBFnV+KwPxRNUNK6lYk2y1WSKour4hJN0SMkoaNV8h
# yyADiX1xuTxKaXN12HgR+8WulU2d6zhzXomJ2PleI9V2yfmfXSPGYanGgxzqI+Sh
# oOGLomMd3mJt92nm7Mheng/TBeSA2z4I78JpwGpTRHiT7yHqBiV2ngUIyCtd0pZ8
# zg3S7bk4QC4RrcnKJ3FbjyPAGogmoiZ33c1HG93Vp6lJ415ERcC7bFQMRbxqrMVA
# Niav1k425zYyFMyLNyE1QulQSgDpW9rtvVcIH7WvG9sqYup9j8z9J1XqbBZPJ5XL
# ln8mS8wWmdDLnBHXgYly/p1DhoQo5fkCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQE
# AwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1Ud
# IAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUv
# cyl2mi91jGogj57IbzAdBgNVHQ4EFgQUn1csA3cOKBWQZqVjXu5Pkh92oFswWgYD
# VR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYB
# BQUHAQEEgYMwgYAwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBYBggrBgEFBQcwAoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkq
# hkiG9w0BAQsFAAOCAgEAPa0eH3aZW+M4hBJH2UOR9hHbm04IHdEoT8/T3HuBSyZe
# q3jSi5GXeWP7xCKhVireKCnCs+8GZl2uVYFvQe+pPTScVJeCZSsMo1JCoZN2mMew
# /L4tpqVNbSpWO9QGFwfMEy60HofN6V51sMLMXNTLfhVqs+e8haupWiArSozyAmGH
# /6oMQAh078qRh6wvJNU6gnh5OruCP1QUAvVSu4kqVOcJVozZR5RRb/zPd++PGE3q
# F1P3xWvYViUJLsxtvge/mzA75oBfFZSbdakHJe2BVDGIGVNVjOp8sNt70+kEoMF+
# T6tptMUNlehSR7vM+C13v9+9ZOUKzfRUAYSyyEmYtsnpltD/GWX8eM70ls1V6QG/
# ZOB6b6Yum1HvIiulqJ1Elesj5TMHq8CWT/xrW7twipXTJ5/i5pkU5E16RSBAdOp1
# 2aw8IQhhA/vEbFkEiF2abhuFixUDobZaA0VhqAsMHOmaT3XThZDNi5U2zHKhUs5u
# HHdG6BoQau75KiNbh0c+hatSF+02kULkftARjsyEpHKsF7u5zKRbt5oK5YGwFvgc
# 4pEVUNytmB3BpIiowOIIuDgP5M9WArHYSAR16gc0dP2XdkMEP5eBsX7bf/MGN4K3
# HP50v/01ZHo/Z5lGLvNwQ7XHBx1yomzLP8lx4Q1zZKDyHcp4VQJLu2kWTsKsOqQw
# ggauMIIElqADAgECAhAHNje3JFR82Ees/ShmKl5bMA0GCSqGSIb3DQEBCwUAMGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBH
# NDAeFw0yMjAzMjMwMDAwMDBaFw0zNzAzMjIyMzU5NTlaMGMxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1
# c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggIiMA0GCSqG
# SIb3DQEBAQUAA4ICDwAwggIKAoICAQDGhjUGSbPBPXJJUVXHJQPE8pE3qZdRodbS
# g9GeTKJtoLDMg/la9hGhRBVCX6SI82j6ffOciQt/nR+eDzMfUBMLJnOWbfhXqAJ9
# /UO0hNoR8XOxs+4rgISKIhjf69o9xBd/qxkrPkLcZ47qUT3w1lbU5ygt69OxtXXn
# HwZljZQp09nsad/ZkIdGAHvbREGJ3HxqV3rwN3mfXazL6IRktFLydkf3YYMZ3V+0
# VAshaG43IbtArF+y3kp9zvU5EmfvDqVjbOSmxR3NNg1c1eYbqMFkdECnwHLFuk4f
# sbVYTXn+149zk6wsOeKlSNbwsDETqVcplicu9Yemj052FVUmcJgmf6AaRyBD40Nj
# gHt1biclkJg6OBGz9vae5jtb7IHeIhTZgirHkr+g3uM+onP65x9abJTyUpURK1h0
# QCirc0PO30qhHGs4xSnzyqqWc0Jon7ZGs506o9UD4L/wojzKQtwYSH8UNM/STKvv
# mz3+DrhkKvp1KCRB7UK/BZxmSVJQ9FHzNklNiyDSLFc1eSuo80VgvCONWPfcYd6T
# /jnA+bIwpUzX6ZhKWD7TA4j+s4/TXkt2ElGTyYwMO1uKIqjBJgj5FBASA31fI7tk
# 42PgpuE+9sJ0sj8eCXbsq11GdeJgo1gJASgADoRU7s7pXcheMBK9Rp6103a50g5r
# mQzSM7TNsQIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4E
# FgQUuhbZbU2FL3MpdpovdYxqII+eyG8wHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5n
# P+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMIMHcG
# CCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# Y29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# aUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8v
# Y3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAgBgNV
# HSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggIB
# AH1ZjsCTtm+YqUQiAX5m1tghQuGwGC4QTRPPMFPOvxj7x1Bd4ksp+3CKDaopafxp
# wc8dB+k+YMjYC+VcW9dth/qEICU0MWfNthKWb8RQTGIdDAiCqBa9qVbPFXONASIl
# zpVpP0d3+3J0FNf/q0+KLHqrhc1DX+1gtqpPkWaeLJ7giqzl/Yy8ZCaHbJK9nXzQ
# cAp876i8dU+6WvepELJd6f8oVInw1YpxdmXazPByoyP6wCeCRK6ZJxurJB4mwbfe
# Kuv2nrF5mYGjVoarCkXJ38SNoOeY+/umnXKvxMfBwWpx2cYTgAnEtp/Nh4cku0+j
# Sbl3ZpHxcpzpSwJSpzd+k1OsOx0ISQ+UzTl63f8lY5knLD0/a6fxZsNBzU+2QJsh
# IUDQtxMkzdwdeDrknq3lNHGS1yZr5Dhzq6YBT70/O3itTK37xJV77QpfMzmHQXh6
# OOmc4d0j/R0o08f56PGYX/sr2H7yRp11LB4nLCbbbxV7HhmLNriT1ObyF5lZynDw
# N7+YAN8gFk8n+2BnFqFmut1VwDophrCYoCvtlUG3OtUVmDG0YgkPCr2B2RP+v6TR
# 81fZvAT6gt4y3wSJ8ADNXcL50CN/AAvkdgIm2fBldkKmKYcJRyvmfxqkhQ/8mJb2
# VVQrH4D6wPIOK+XW+6kvRBVK5xMOHds3OBqhK/bt1nz8MIIFjTCCBHWgAwIBAgIQ
# DpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAx
# MDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMM
# RGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQD
# ExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aa
# za57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllV
# cq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT
# +CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd
# 463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+
# EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92k
# J7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5j
# rubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7
# f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJU
# KSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/Y+wh
# X8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQAB
# o4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5n
# P+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0P
# AQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IB
# AQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229
# GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FD
# RJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVG
# amlUsLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCw
# rFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvR
# XKwYw02fc7cBqZ9Xql4o4rmUMYIDdjCCA3ICAQEwdzBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBAhALrma8Wrp/lYfG
# +ekE4zMEMA0GCWCGSAFlAwQCAQUAoIHRMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAcBgkqhkiG9w0BCQUxDxcNMjUwNjIzMjM0NDE4WjArBgsqhkiG9w0BCRAC
# DDEcMBowGDAWBBTb04XuYtvSPnvk9nFIUIck1YZbRTAvBgkqhkiG9w0BCQQxIgQg
# 7IuCNmu1MBXXrAXyeUpyK0qNWDl7z0PZGsuON8PiQEgwNwYLKoZIhvcNAQkQAi8x
# KDAmMCQwIgQgdnafqPJjLx9DCzojMK7WVnX+13PbBdZluQWTmEOPmtswDQYJKoZI
# hvcNAQEBBQAEggIApQcEjvXTyWUhE5EelCHxhlVbYOmg/kZGEytMzGvLIy+NvBwV
# TbG8277n7ScPCeSA18KwH+Y7Ij6gBeDi2rto4QQU3bcDYuq+VC8AK0aNRJfI3vDX
# n1OYt+1MiDpc02TQPprckVtOFqCXkDX2YCQ67kJou2qUlbTrpBBycJb8Qjioq0S9
# YYUHqAES2CcDG6GMbTl1OKdEVMC8mOtO54NosDWTzbOZoMDcxyIi0X/Eay5yFeqG
# NcEHEOr5upvGg9c9HXVsJO458G7k4nXIRXCLS9QSfDfsGWVuc7XrjGamvB2EO0UN
# P0WK0KmNoHEwVR/m4UsZZdGow+9HfHiUrtBButp095Xzqlpgk6d70vbirCP146vB
# PO4AVxb4CJB6Ju7mXukqvIR2yRRPMEKLYIKUBDD1Lg1AWy6Qt0SXa4LV3shCK7nl
# WIeQG8ddyD9/dG/JlbJchF5CL/xp9KWm663sL0FG5dOTKqJyZqQ6Cqq+kwq0qGu7
# KAyPvRLckFioJUQJDWUMCCvUoUpdlA+hvm3u5giYwOUZIwrbEi/uJwXO8ucXbJUa
# 4w/GgXWw+WYo/a/sS8cg28E3+zeQqe0UI79URbp9XbZ879mmno5VaVacr9rmlUbT
# FGvYkGFnwPt0JwRQXkAjrt4EcpGxqSh/5THKViyjMm+9TgeLdftRw0mIi0c=
# SIG # End signature block
