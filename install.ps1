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

# Writes a real Lua file that dot-sources the repo copy. Used where a symlink
# is rejected by a consumer -- see the WezTerm note below. Needs no elevation,
# which New-Item -ItemType SymbolicLink does unless Developer Mode is on.
function New-LoaderShim {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Target,
        [string]$Comment = ""
    )

    $targetPath = Join-Path $PSScriptRoot $Target
    if (-not (Test-Path $targetPath)) {
        Write-Warning "Target not found: $targetPath"
        return
    }

    $parent = Split-Path $Path -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $existing = Get-Item $Path -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -eq "SymbolicLink") {
        Remove-Item $Path -Force
    }

    $relative = $targetPath.Replace($HOME, '') -replace '^\\', ''
    $body = "$Comment`nreturn dofile(os.getenv('USERPROFILE') .. [[\$relative]])`n"
    Set-Content -Path $Path -Value $body -Encoding utf8
    Write-Host "Shimmed: $Path -> $targetPath" -ForegroundColor Green
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

# WezTerm. Not a symlink: the nightly GUI enables the Windows redirection-trust
# process mitigation, which refuses to traverse reparse points it does not
# consider trusted and dies with "untrusted mount point (os error 448)" before
# it can read a linked config. A real file that dofile()s the repo copy keeps
# the config version-controlled without a reparse point in the path.
New-LoaderShim -Path "$HOME\.wezterm.lua" -Target "wezterm.lua" -Comment @'
-- Loader shim for the dotfiles config -- deliberately a real file, not a
-- symlink; see install.ps1 for why. Edit dotfiles\wezterm.lua, not this.
'@

# Agent skills (pi). Skills are directories, so each one is linked by name.
New-SymbolicLinkSafe -Link "$HOME\.pi\agent\skills\git-commit-messages" -Target "pi\skills\git-commit-messages"

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
