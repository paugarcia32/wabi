# Wabi for VSCode / Cursor

Two themes: **Wabi Dark** and **Wabi Light**. Cursor uses the same extension.

## Install (from this repo)

Build the `.vsix` package and install it (in VSCode, and in Cursor if its `cursor` command is available):

```powershell
pwsh ports/vscode/package.ps1 -Install
```

The script packs the extension by hand, so `vsce` isn't needed. The package lands in `ports/vscode/dist/`, which git ignores. Without `-Install` it only builds the file, which you can install with **Extensions: Install from VSIX…**.

Then run **Preferences: Color Theme** and pick **Wabi Dark** or **Wabi Light**.

Linking this folder into `~/.vscode/extensions` doesn't work: VSCode only loads extensions listed in its own `extensions.json`.

To follow the system light/dark mode:

```json
"window.autoDetectColorScheme": true,
"workbench.preferredDarkColorTheme": "Wabi Dark",
"workbench.preferredLightColorTheme": "Wabi Light"
```

## Notes

- Don't edit `themes/wabi-*-color-theme.json` directly: edit `palette/palette.json` or the `.tmpl` template and run `node generator/build.js`, then `pwsh ports/vscode/package.ps1 -Install` and **Developer: Reload Window**.
- Semantic highlighting is on, so languages with a language server (TypeScript, Rust, Python…) get richer colours.
- Publishing to the VS Marketplace and Open VSX (where Cursor installs from) will need a LICENSE file.
