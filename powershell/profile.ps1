# PowerShell profile

# Starship prompt, from a cached init script. `starship init powershell` emits a
# stub that shells out a second time for --print-full-init, so the stock one-liner
# costs two subprocesses per shell; caching saves ~60ms. The cache regenerates
# when starship.exe is newer than it; to force it, delete ~/.cache/starship/init.ps1
$_StarshipExe = (Get-Command starship -CommandType Application -ErrorAction SilentlyContinue).Source
if ($_StarshipExe) {
    $_StarshipCache = "$HOME\.cache\starship\init.ps1"
    if (-not (Test-Path $_StarshipCache) -or
        (Get-Item $_StarshipExe).LastWriteTimeUtc -gt (Get-Item $_StarshipCache).LastWriteTimeUtc) {
        New-Item -ItemType Directory -Force -Path (Split-Path $_StarshipCache) | Out-Null
        # Written with an explicit BOM: the init contains a U+276F prompt glyph, and
        # Windows PowerShell 5.1 decodes BOM-less files as ANSI, which mangles it.
        # Staged through a temp file so an interrupted write cannot leave every
        # future shell dot-sourcing a truncated script.
        $_StarshipTmp = "$_StarshipCache.$PID.tmp"
        $_StarshipEnc = [Console]::OutputEncoding
        try {
            # starship emits UTF-8. PowerShell decodes a child's stdout using
            # [Console]::OutputEncoding, which is the OEM code page when stdout is
            # redirected -- that turns the U+276F prompt glyph into "ÔØ»".
            try { [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new() } catch { }
            $_StarshipInit = (& $_StarshipExe init powershell --print-full-init) -join "`n"
            [System.IO.File]::WriteAllText($_StarshipTmp, $_StarshipInit, [System.Text.UTF8Encoding]::new($true))
            Move-Item $_StarshipTmp $_StarshipCache -Force
        } catch {
            Remove-Item $_StarshipTmp -ErrorAction SilentlyContinue
        } finally {
            try { [Console]::OutputEncoding = $_StarshipEnc } catch { }
        }
    }
    if (Test-Path $_StarshipCache) { . $_StarshipCache }
}
Remove-Variable _StarshipExe, _StarshipCache, _StarshipTmp, _StarshipInit, _StarshipEnc -ErrorAction SilentlyContinue

# Pull the gh CLI token into this session only (for Terraform's GitHub provider).
# Deliberately not a persistent env var -- that would leak the token to every
# child process. Run it in the shell where you need it.
function Set-GitHubToken {
    $token = gh auth token 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $token) {
        Write-Error "Not logged in to gh. Run: gh auth login"
        return
    }
    $env:GITHUB_TOKEN = $token
    Write-Host "GITHUB_TOKEN set for this session." -ForegroundColor DarkGray
}
