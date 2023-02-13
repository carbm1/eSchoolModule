#
# Module manifest for module 'eSchoolModule'
#
# Author: Craig Millsap, CAMTech Computer Services, LLC.
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'eSchoolModule.psm1'
    
    # Version number of this module.
    ModuleVersion = '23.2.9'
    
    # ID used to uniquely identify this module
    GUID = 'b9c99138-35f7-4095-a9e1-5ea07297c903'
    
    # Author of this module
    Author = 'Craig Millsap'
    
    # Company or vendor of this module
    CompanyName = 'CAMTech Computer Services, LLC'
    
    # Copyright statement for this module
    Copyright = '(c) CAMTech Computer Services, LLC. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Module for pulling data from the Arkansas Cognos Data Servers'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '7.0'
    
    # Modules that must be imported into the global environment prior to importing this module
    #RequiredModules = @()
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = 'Assert-eSPSession','Clear-eSPFailedTask','Connect-ToeSchool','Disconnect-FromeSchool',
        'Get-eSPFile','Get-eSPFileList','Get-eSPSchools','Get-eSPStudentDetails','Get-eSPStudents','Get-eSPTaskList',
        'Invoke-eSPDownloadDefinition','Invoke-eSPUploadDefinition','Remove-eSchoolConfig','Set-eSchoolConfig',
        'Show-eSchoolConfig','Submit-eSPFile','Update-eSchoolPassword'
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    
    # Variables to export from this module
    # VariablesToExport = @()
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    # FileList = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'Arkansas','eSchool','Automation'
    
            # A URL to the license for this module.
            LicenseUri = 'https://github.com/AR-k12code/eSchoolModule/blob/master/LICENSE'
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/AR-k12code/eSchoolModule'
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
            # Prerelease string of this module
            # Prerelease = ''
    
            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false
    
            # External dependent modules of this module
            # ExternalModuleDependencies = @()
    
        } # End of PSData hashtable
    
     } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
}