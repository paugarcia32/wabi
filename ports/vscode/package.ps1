# Packages the extension into dist/wabi-theme-<version>.vsix with vsce, Microsoft's
# official packager (fetched through npx, pinned below), so the file is ready for the
# VS Marketplace and Open VSX.
#
# Usage (from the repo root, after `node generator/build.js`):
#   pwsh ports/vscode/package.ps1            # build the .vsix
#   pwsh ports/vscode/package.ps1 -Install   # build and install it in VSCode (and Cursor if present)

param([switch]$Install)

$ErrorActionPreference = "Stop"
$VsceVersion = "4.1.0"

$root = $PSScriptRoot
$pkg = Get-Content (Join-Path $root "package.json") -Raw | ConvertFrom-Json
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force $dist | Out-Null
$vsix = Join-Path $dist "$($pkg.name)-$($pkg.version).vsix"

Push-Location $root
try {
  npx --yes "@vscode/vsce@$VsceVersion" package --no-dependencies --out $vsix
  if ($LASTEXITCODE -ne 0) { throw "vsce package failed" }
} finally { Pop-Location }

Write-Host "built $vsix"

if ($Install) {
  foreach ($cli in "code", "cursor") {
    if (Get-Command $cli -ErrorAction SilentlyContinue) {
      & $cli --install-extension $vsix --force
    }
  }
}
