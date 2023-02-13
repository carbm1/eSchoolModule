# eSchoolModule
These scripts come without warranty of any kind. Use them at your own risk. I assume no liability for the accuracy, correctness, completeness, or usefulness of any information provided by this site nor for any sort of damages using these scripts may cause.

The eSchool Powershell Module requires PowerShell 7

## Installation Process
Open PowerShell Window as Administrator
````
mkdir "C:\Program Files\PowerShell\Modules\eSchoolModule"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AR-k12code/eSchoolModule/master/eSchoolModule.psd1" -OutFile "C:\Program Files\PowerShell\Modules\eSchoolModule\eSchoolModule.psd1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/AR-k12code/eSchoolModule/master/eSchoolModule.psm1" -OutFile "C:\Program Files\PowerShell\Modules\eSchoolModule\eSchoolModule.psm1"
````

## Initial Configuration
````
PS C:\Scripts> Set-eSchoolConfig -username 0400cmillsap
Please provide your eSchool Password: ********************
````
Provide a name for a specific configuration. Example: If you have multiple users with different privileges.
````
PS C:\Scripts> Set-CognosConfig -ConfigName "Judy" -username 0400judy
Please provide your Cognos Password: ********************
````

### Update Saved Password
````
Update-eSchoolPassword [[-ConfigName] <String>] [[-Password] <SecureString>]
````

## Tutorial
Coming Soon
[![tutorial](/images/youtube_thumbnail.jpg)](https://www.youtube.com/@camtechcs)

### Establish Connection to eSchool
````
Connect-ToeSchool [[-ConfigName] <String>] [-TrainingSite] [[-Database] <String>]
````

### Get Task List
````
Get-eSPTaskList [-ActiveTasksOnly] [-ErrorsOnly]
````

### Clear Task
````
Clear-eSPFailedTask [-TaskKey] <String>
````

### List Files
````
Get-eSPFileLIst
````

### Get a File
````
Get-eSPFile -FileName <String> [-OutFile <String>] [-AsObject] [-Raw] [-Delimeter <String>]
````

### Upload a File
````
Submit-eSPFile [-InFile] <Object>
````

### Start a Download Definition
````
Invoke-eSPDownloadDefinition [-InterfaceID] <String> [-ActiveStudentsOnly] [-Wait]
````

### Start an Upload Definition
````
Invoke-eSPUploadDefinition [-InterfaceID] <String> [[-RunMode] <String>] [-DoNotUpdateExistingRecords] [-InsertNewRecords] [-UpdateBlankRecords] [-Wait]
````

### List School Ids
By default will only return schools with a default calendar assigned.
````
Get-eSPSchools [-All]
````

### Get Student Info
````
# Get All Active Students
Get-eSPStudents

# Get Students from a Specific Building
Get-eSPStudents -Building 16

# Get Students in Grade(s)
Get-eSPStudents -Grade '01','08','KF'

# Additional Options
Get-eSPStudents [-InActive] [-Graduated] [-All]

# Include Additional Tables
Get-eSPStudents -Grade '01' -IncludeTable reg_academic,reg_notes
````


### List Staff Catalog
````
Get-eSPStaffCatalog [[-Building] <Int32>]
````

### List eSchool Users
````
Get-eSPSecUsers
````

### List eSchool Security Roles
````
Get-eSPSecRoles
````

### List Master Schedule
````
Get-eSPMasterSchedule
````

# PreDefined Upload/Download Defininitions
Built in download definitions will start with ESMD and upload defintions will start with ESMU. For the last character we will use [0-9] then [A-Z].
- ESMD0 - "eSchoolModule - Email Download Definition" - Download Contact_id,Student_id, and Email. Then you can process to fix them.
- ESMD1 - "eSchoolModule - Guardian Duplication" - Download all the information needed to dedupe guardian contacts.

- ESMU0 - "eSchoolModule - Email Upload Definition" - Upload Student Emails by Contact_id,Email
- ESMU1 - "eSchoolModule - Web Access Upload Definition" - Enable Web Access for Contacts
- ESMU2 - "eSchoolModule - Move Duplicate Guardian Priority" - Move Duplicate Guardians to Priority of 99
- ESMU2 - "eSchoolModule - Connect Duplicate Guardians" - Connect the Existing Contacts to Students
- ESMU3 - "eSchoolModule - Merge Duplicate Guardian Phone Numbers" - Because we don't want lost data.

## Definition Creator
Think Bigger!
````
$newDefinition = New-espDefinitionTemplate -InterfaceId STUID -Description "Pull Student Id Numbers"
$newDefinition.UploadDownloadDefinition.InterfaceHeaders += New-eSPInterfaceHeader `
	-InterfaceId "STUID" `
	-HeaderId 1 `
	-HeaderOrder 1 `
	-FileName "studentids.csv" `
	-TableName "reg" `
	-Description "Pull Student Id Numbers" `
    -AdditionalSql 'WHERE CONVERT(DATETIME,CHANGE_DATE_TIME,101) >= DateAdd(Hour, DateDiff(Hour, 0, GetDate())-72, 0)'
	
$newDefinition.UploadDownloadDefinition.InterfaceHeaders[0].InterfaceDetails +=	New-eSPDefinitionColumn `
	-InterfaceId "STUID" `
	-HeaderId 1 `
	-TableName "reg" `
	-FieldId 1 `
	-FieldOrder 1 `
	-ColumnName STUDENT_ID `
	-FieldLength 255

$newDefinition.UploadDownloadDefinition.InterfaceHeaders[0].InterfaceDetails +=	New-eSPDefinitionColumn `
	-InterfaceId "STUID" `
	-HeaderId 1 `
	-TableName "reg" `
	-FieldId 2 `
	-FieldOrder 2 `
	-ColumnName CURRENT_STATUS `
	-FieldLength 255

New-eSPDefinition -Definition $newDefinition

Invoke-eSPDownloadDefinition -InterfaceId STUID -Wait

$studentIds = Get-eSPFile -FileName "studentids.csv" -AsObject | Select-Object -First 5
````

## Bulk Export Download Definitions
Think even bigger!

Every row will have a record delimiter of '#!#'.  This is because eSchool doesn't properly escape characters/carriage returns/line feeds.
````
$TablesToExport = @("REG","REG_STU_CONTACT","REG_CONTACT","REG_CONTACT_PHONE","REG_NOTES")

New-eSPBulkDownloadDefinition -Tables $TablesToExport -InterfaceId "REG00" -DoNotLimitSchoolYear -Delimiter "|" -Force

Assert-eSPSession -Force #don't know why you have to do this after creating a Bulk Download Definition.

Invoke-espDownloadDefinition -InterfaceID "REG00" -Wait

$TablesToExport | ForEach-Object {
	New-Variable -Name $PSItem -Value (Get-eSPFile -FileName "$($PSItem).csv" -Raw | ConvertFrom-CSV -Delimiter '|') -Force
}

$REG | Measure-Object
#Count             : 725
````

## Verifying and Sanitizing your Files
There are multiple ways of cleaning up the files exported. You get to choose which way is best for you. This can be because eSchool does not escape Return Carriages, Line Feeds, or extra delimiters in fields with a download definition. Using the Delimiter "Q" for quoting fields doesn't help.

### CSVKit
This will create a file called reg_out.csv in the same folder. It will remove any lines that do not match the columns expected.  
````
# Exmaple of no errors
PS C:\eSchoolModule> csvclean.exe -d '|' reg_contact.csv
No errors.

# Example of row with the incorrect number of delimiters because of carriage returns and fixed.
PS C:\eSchoolModule> csvclean.exe -d '|' reg.csv
1 error logged to .\REG_err.csv
2 rows were joined/reduced to 1 rows after eliminating expected internal line breaks.

# Example of incorrect number of delimiters to return a complete record. Will be stripped from the resulting file.
PS c:\eSchoolModule> csvclean.exe -d '|' .\REG.csv
4 errors logged to .\REG_err.csv
````

### Directly Replace CR/LF
We can directly do replacements on the carriage returns and line feeds before we even save the file to disk. The record delimiter of '#!#' is what makes this possible.
````
$reg_notes = Get-eSPFile -FileName reg_notes.csv -Raw
$reg_notes = $reg_notes -replace "`n",'{LF}' -replace "`r",'{CR}' -replace '\|#!#{CR}{LF}',"`r`n"
$reg_notes | Out-File ".\reg_notes.csv"

#or as one line.
(Get-eSPFile -FileName reg_notes.csv -Raw) -replace "`n",'{LF}' -replace "`r",'{CR}' -replace '\|#!#{CR}{LF}',"`r`n" | Out-File ".\reg_notes.csv" -NoNewLine
````

## Import Into Database

### Microsoft SQL Server
````
$dbConn= @{
	hostname = "1.2.3.4"
	dbname = "schoolsms"
	username = 'smsadmin'
	password = 'xyz' #you should make this safer.
}

$TablesToExport | ForEach-Object {
	Import-DbaCsv -Path "$($PSitem).csv" -SqlInstance $($dbConn.hostname) -database $($dbConn.dbname) -Table "import_($PSitem)" -AutoCreateTable -SqlCredential (New-Object System.Management.Automation.PSCredential ("$($dbConn.username)", (ConvertTo-SecureString "$($dbConn.password)" -AsPlainText -Force))) -Truncate
}
````

### SQLite
````
$TablesToExport | ForEach-Object {
	& csvsql.exe -I --db "sqlite:///schoolsms.sqlite3" --insert --overwrite --blanks --tables "import_$($PSItem)" "$($PSItem).csv"
}
````

### MariaDB or MySQL
````
$dbConn= @{
	hostname = "1.2.3.4"
	dbname = "schoolsms"
	useranme = 'smsadmin'
	password = 'xyz' #you should make this safer.
}

$TablesToExport | ForEach-Object {
	& csvsql.exe -I --db "mysql+mysqlconnector://$($dbConn.username):$($dbConn.password)@$($dbConn.hostname)/$($dbConn.dbname)?charset=utf8mb4" --insert --overwrite --tables "import_$($PSItem)" "$($PSItem).csv"
}
````

# What Now?
PROFIT?