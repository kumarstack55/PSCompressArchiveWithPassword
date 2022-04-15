# PSCompressArchiveWithPassword

Compress the archive with a password.

## Requirements

* 7zip

## Usage

```powershell
$SecureString = ConvertTo-SecureString "s3cret" -AsPlainText -Force

# Compress zip archive with password.
Compress-ArchiveWithPassword -DestinationPath a.zip -LiteralPath file1.txt -SecureString $SecureString

# Compress zip archive with password using AES256 encryption method.
Compress-ArchiveWithPassword -DestinationPath a.zip -LiteralPath file1.txt -SecureString $SecureString -EncryptionMethodId AES256
```

## Installation

### Install from PowerShell Gallery

```powershell
Install-Module -Name PSCompressArchiveWithPassword
```

### Install from source

```powershell
# Install the module into LocalApp directory.
cd $env:LOCALAPPDATA
gh repo clone kumarstack55/PSCompressArchiveWithPassword

# or, import the module.
Import-Module -Name $env:LOCALAPPDATA\PSCompressArchiveWithPassword\PSCompressArchiveWithPassword\PSCompressArchiveWithPassword.psd1 -Force -Verbose
```