# Publishes the Obsidian port to github.com/paugarcia32/wabi-obsidian, the repo the
# Obsidian community directory installs from (it needs manifest.json at the repo root
# and a GitHub release tagged with the bare manifest version, e.g. "0.1.0").
#
# Usage (from the wabi repo root, after `node generator/build.js`):
#   pwsh ports/obsidian/publish.ps1 -WorkDir <folder for a local clone>
#   pwsh ports/obsidian/publish.ps1 -WorkDir <folder> -Release   # also create the release
#
# Bump "version" in ports/obsidian/manifest.json before publishing a new release.

param(
  [Parameter(Mandatory)] [string]$WorkDir,
  [switch]$Release,
  [string]$Repo = "paugarcia32/wabi-obsidian"
)

$ErrorActionPreference = "Stop"
$src = $PSScriptRoot
$gh = (Get-Command gh -ErrorAction SilentlyContinue).Source
if (-not $gh) { $gh = "C:\Program Files\GitHub CLI\gh.exe" }

$version = (Get-Content (Join-Path $src "manifest.json") -Raw | ConvertFrom-Json).version
$clone = Join-Path $WorkDir "wabi-obsidian"

if (-not (Test-Path (Join-Path $clone ".git"))) {
  New-Item -ItemType Directory -Force $WorkDir | Out-Null
  git clone -q "https://github.com/$Repo.git" $clone
}
git -C $clone fetch -q origin 2>$null
if (git -C $clone rev-parse --verify -q origin/main) { git -C $clone checkout -q -B main origin/main }
else { git -C $clone checkout -q -B main }

# Files the store needs at the repo root.
Copy-Item (Join-Path $src "manifest.json") $clone -Force
Copy-Item (Join-Path $src "theme.css") $clone -Force
Copy-Item (Join-Path $src "store/README.md") (Join-Path $clone "README.md") -Force
Copy-Item (Join-Path $src "../../LICENSE") $clone -Force
$shot = Join-Path $src "store/screenshot.png"
if (Test-Path $shot) { Copy-Item $shot $clone -Force } else { Write-Warning "No store/screenshot.png yet: the store listing needs one." }

git -C $clone add -A
if (git -C $clone status --porcelain) {
  git -C $clone commit -q -m "Wabi $version"
  git -C $clone push -q origin main
  Write-Host "pushed Wabi $version to $Repo"
} else {
  Write-Host "no changes to push"
}

if ($Release) {
  & $gh release view $version --repo $Repo *> $null
  if ($LASTEXITCODE -eq 0) { throw "release $version already exists: bump the version in manifest.json first" }
  & $gh release create $version --repo $Repo --target main --title "Wabi $version" `
    --notes "Wabi $version for Obsidian. Generated from https://github.com/paugarcia32/wabi." `
    (Join-Path $clone "manifest.json") (Join-Path $clone "theme.css")
}
