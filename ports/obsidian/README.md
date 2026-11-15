# Wabi for Obsidian

One theme with both variants: Obsidian's own light/dark switch picks between Wabi Light and Wabi Dark.

## Install

Wabi is in Obsidian's community theme store: open **Settings → Appearance → Themes → Manage**, search for **Wabi**, then **Install and use**. Updates arrive automatically.

Then pick Light, Dark or "Adapt to system" in **Settings → Appearance**.

## Install from this repo (development)

To try changes before they're released, link this folder into your vault as `.obsidian/themes/Wabi` (rebuilds then apply without copying). Uninstall the store version first: the store writes into that same folder, and through the link it would overwrite the generated files here.

```powershell
cmd /c mklink /J "<vault>\.obsidian\themes\Wabi" "<repo>\ports\obsidian"
```

On macOS / Linux: `ln -s "<repo>/ports/obsidian" "<vault>/.obsidian/themes/Wabi"`.

Or copy `manifest.json` and `theme.css` into `<vault>/.obsidian/themes/Wabi/`.

Then open **Settings → Appearance → Themes → Manage** (or the theme dropdown), pick **Wabi**, and choose Light, Dark or "Adapt to system".

## Notes

- Don't edit `theme.css` directly: edit `palette/palette.json` or `theme.css.tmpl` and run `node generator/build.js`. Obsidian reloads the theme when the file changes; if it doesn't, switch themes and back.
- The theme only sets Obsidian's CSS variables (base scale, accent, text, links, tags, code, graph), so it stays compatible with plugins and snippets.

## Publishing (maintainers)

The Obsidian community directory installs from [paugarcia32/wabi-obsidian](https://github.com/paugarcia32/wabi-obsidian), which needs `manifest.json` at its root and a release tagged with the bare version (`0.1.0`). That repo only holds release files; everything is generated here.

1. Run `node generator/build.js`.
2. For a new version, bump `version` in `manifest.json`.
3. Run `pwsh ports/obsidian/publish.ps1 -WorkDir <folder> -Release`. It copies `manifest.json`, `theme.css`, `store/README.md`, `store/screenshot.png` and the LICENSE to `wabi-obsidian`, pushes them, and creates the release with `manifest.json` and `theme.css` attached. Leave out `-Release` to update only the files (for example a new screenshot).
