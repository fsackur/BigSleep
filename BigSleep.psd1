@{
    Description          = 'A Powershell client for the HCL BigFix REST API.'
    ModuleVersion        = '0.0.1'
    HelpInfoURI          = 'https://pages.github.com/fsackur/BigSleep'

    GUID                 = '57e6bf56-e137-42a2-903a-27be1d2d51d0'

    Author               = 'Freddie Sackur'
    CompanyName          = 'DustyFox'
    Copyright            = '(c) 2020 Freddie Sackur. All rights reserved.'

    RootModule           = 'BigSleep.psm1'

    FunctionsToExport    = @(
        '*'
    )

    PrivateData          = @{
        PSData = @{
            LicenseUri = 'https://raw.githubusercontent.com/fsackur/BigSleep/main/LICENSE'
            ProjectUri = 'https://github.com/fsackur/BigSleep'
            Tags       = @(
                'BigFix',
                'HCL',
                'IBM',
                'Fixlet',
                'XSD'
            )
        }
    }
}

