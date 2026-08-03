# PowerShell profile

# Starship prompt
Invoke-Expression (&starship init powershell)

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
