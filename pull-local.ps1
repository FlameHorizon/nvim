# Copies the live Neovim config into this repository.
# Only adds/updates files; nothing in the repo is deleted.

$source = Join-Path $env:LOCALAPPDATA "nvim"
$dest   = $PSScriptRoot

robocopy $source $dest /E /XD ".git" /XF "pull-local.ps1" /NFL /NDL /NJH /NJS /NP

# robocopy exit codes 0-7 mean success (8+ means failure)
if ($LASTEXITCODE -ge 8) {
    Write-Error "robocopy failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Copied $source -> $dest"
exit 0
