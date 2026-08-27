# Windows dotfiles installation script
# Run from the dotfiles directory: .\install.ps1

$ErrorActionPreference = "Stop"
$DotfilesPath = $PSScriptRoot

function New-SymbolicLinkSafe {
    param (
        [string]$Link,
        [string]$Target
    )

    $TargetPath = Join-Path $DotfilesPath $Target

    if (-not (Test-Path $TargetPath)) {
        Write-Warning "Target does not exist: $TargetPath"
        return
    }

    $LinkParent = Split-Path $Link -Parent
    if (-not (Test-Path $LinkParent)) {
        New-Item -ItemType Directory -Path $LinkParent -Force | Out-Null
        Write-Host "Created directory: $LinkParent" -ForegroundColor Gray
    }

    if (Test-Path $Link) {
        $item = Get-Item $Link -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Remove-Item $Link -Force
        } else {
            $backup = "$Link.backup"
            Write-Warning "Backing up existing file: $Link -> $backup"
            Move-Item $Link $backup -Force
        }
    }

    New-Item -ItemType SymbolicLink -Path $Link -Target $TargetPath -Force | Out-Null
    Write-Host "Linked: $Link -> $TargetPath" -ForegroundColor Green
}

Write-Host "Installing Windows dotfiles..." -ForegroundColor Cyan
Write-Host ""

# Hyper terminal
New-SymbolicLinkSafe -Link "$env:APPDATA\Hyper\.hyper.js" -Target "hyper.js"

# PowerShell profiles
New-SymbolicLinkSafe -Link "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "powershell\profile.ps1"
New-SymbolicLinkSafe -Link "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Target "powershell\profile.ps1"

# Starship config
New-SymbolicLinkSafe -Link "$HOME\.config\starship.toml" -Target "starship.toml"

# herdr terminal multiplexer
New-SymbolicLinkSafe -Link "$env:APPDATA\herdr\config.toml" -Target "herdr\config.toml"

# WezTerm
New-SymbolicLinkSafe -Link "$HOME\.wezterm.lua" -Target "wezterm.lua"

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
