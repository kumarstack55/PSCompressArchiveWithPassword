Set-StrictMode -Version Latest

class CompressArchiveWithPasswordException : Exception {
    CompressArchiveWithPasswordException([String]$Message) : base([String]$Message) {}
}

class CommandNotFoundException : CompressArchiveWithPasswordException {
    CommandNotFoundException([String]$Message) : base([String]$Message) {}
}

class ZipFilePath {
    [string]$FilePath

    ZipFilePath([string]$FilePath) {
        $this.validate($FilePath)
        $this.FilePath = $FilePath
    }

    validate([string]$FilePath) {
        if ([System.IO.Path]::GetExtension($FilePath) -ne '.zip') {
            throw [NotImplementedException]::new(
                "The extension of DestinationPath {0} is not '.zip'." -f $FilePath)
        }
    }
}

function GetCommandOrThrowException {
    param([Parameter(Mandatory)][string]$Name)

    $CommandName = '7z'
    $Command = Get-Command -Name $CommandName -ErrorAction SilentlyContinue
    if (-not $Command) {
        throw [CommandNotFoundException]::new(
            "Command {0} not found." -f $CommandName)
    }
    return $Command
}

function Compress-ArchiveBy7zip {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$DestinationPath,

        [Parameter(Mandatory)]
        [string[]]$LiteralPath,

        [System.Security.SecureString]$SecureString,

        [string]
        [ValidateSet("ZipCrypto", "AES256")]
        $EncryptionMethodId = "ZipCrypto"
    )

    $ArgList = [System.Collections.ArrayList]::new()
    $ArgList.Add('a') | Out-Null

    if ($SecureString -ne $null) {
        $Bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
        $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Bstr)
        $ArgList.Add("-p{0}" -f $Password) | Out-Null
        $ArgList.Add("-mem={0}" -f $EncryptionMethodId) | Out-Null
    }

    $ArgList.Add('--') | Out-Null

    $ZipFilePath = [ZipFilePath]::new($DestinationPath)
    if (Test-Path -LiteralPath $ZipFilePath.FilePath) {
        throw [NotImplementedException]::new(
            "DestinationPath {0} already exists." -f $ZipFilePath.FilePath)
    }
    $ArgList.Add($ZipFilePath.FilePath) | Out-Null

    foreach ($Path in $LiteralPath) {
        if (-not (Test-Path -LiteralPath $Path)) {
            throw [NotImplementedException]::new(
                "LiteralPath {0} does not exists." -f $Path)
        }
    }
    $ArgList.AddRange($LiteralPath)

    $Command = GetCommandOrThrowException -Name 7z
    if ($PSCmdlet.ShouldProcess($DestinationPath)) {
        Start-Process -NoNewWindow -Wait -FilePath $Command.Source -ArgumentList $ArgList
    }
}

function Compress-ArchiveWithPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$DestinationPath,

        [Parameter(Mandatory)]
        [string[]]$LiteralPath,

        [Parameter(Mandatory)]
        [System.Security.SecureString]$SecureString,

        [string]
        [ValidateSet("ZipCrypto", "AES256")]
        $EncryptionMethodId = "ZipCrypto"
    )

    Compress-ArchiveBy7zip -DestinationPath $DestinationPath -LiteralPath $LiteralPath `
        -SecureString $SecureString -EncryptionMethodId $EncryptionMethodId
}

Export-ModuleMember -Function Compress-ArchiveWithPassword
