# Builds dist/wabi-theme-<version>.vsix from this folder without needing vsce.
# Usage (from the repo root):
#   pwsh ports/vscode/package.ps1            # build the .vsix
#   pwsh ports/vscode/package.ps1 -Install   # build and install it in VSCode (and Cursor if present)

param([switch]$Install)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem

$root = $PSScriptRoot
$pkg = Get-Content (Join-Path $root "package.json") -Raw | ConvertFrom-Json
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force $dist | Out-Null
$vsix = Join-Path $dist "$($pkg.name)-$($pkg.version).vsix"
if (Test-Path $vsix) { Remove-Item $vsix }

$manifest = @"
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011" xmlns:d="http://schemas.microsoft.com/developer/vsx-schema-design/2011">
  <Metadata>
    <Identity Language="en-US" Id="$($pkg.name)" Version="$($pkg.version)" Publisher="$($pkg.publisher)" />
    <DisplayName>$($pkg.displayName)</DisplayName>
    <Description xml:space="preserve">$($pkg.description)</Description>
    <Categories>Themes</Categories>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="$($pkg.engines.vscode)" />
    </Properties>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code" />
  </Installation>
  <Dependencies />
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true" />
  </Assets>
</PackageManifest>
"@

$contentTypes = @"
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".json" ContentType="application/json" />
  <Default Extension=".md" ContentType="text/markdown" />
  <Default Extension=".vsixmanifest" ContentType="text/xml" />
</Types>
"@

# Files that go into the extension: package.json, README and the generated themes (no templates).
$files = @("package.json", "README.md") + (Get-ChildItem (Join-Path $root "themes") -Filter "*.json" | ForEach-Object { "themes/$($_.Name)" })

$zip = [System.IO.Compression.ZipFile]::Open($vsix, "Create")
try {
  foreach ($entry in @(@{ Name = "extension.vsixmanifest"; Text = $manifest }, @{ Name = "[Content_Types].xml"; Text = $contentTypes })) {
    $w = New-Object System.IO.StreamWriter(($zip.CreateEntry($entry.Name)).Open())
    $w.Write($entry.Text); $w.Dispose()
  }
  foreach ($f in $files) {
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Join-Path $root $f), "extension/$f") | Out-Null
  }
} finally { $zip.Dispose() }

Write-Host "built $vsix"

if ($Install) {
  foreach ($cli in "code", "cursor") {
    if (Get-Command $cli -ErrorAction SilentlyContinue) {
      & $cli --install-extension $vsix --force
    }
  }
}
