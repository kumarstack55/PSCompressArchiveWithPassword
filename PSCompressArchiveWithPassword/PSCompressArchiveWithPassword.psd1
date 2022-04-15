@{
    ModuleVersion = '1.0.1'
    GUID = '8eea56f7-4f16-4c72-b5e9-f4dab75934d5'
    Author = 'kumarstack55'
    Copyright = '(c) 2022 kumarstack55. All rights reserved.'
    Description = 'Compress the archive with a password.'
    PowerShellVersion = '5.1'
    NestedModules = @('PSCompressArchiveWithPassword.psm1')
    FunctionsToExport = @('Compress-ArchiveWithPassword')
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @()
            LicenseUri = 'https://github.com/kumarstack55/PSCompressArchiveWithPassword/blob/main/LICENSE'
            ProjectUri = 'https://github.com/kumarstack55/PSCompressArchiveWithPassword'
        }
    }
}

