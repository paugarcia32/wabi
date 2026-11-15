# Wabi for Obsidian

One theme with both variants: Obsidian's own light/dark switch picks between Wabi Light and Wabi Dark.

## Install (from this repo)

Link this folder into your vault as `.obsidian/themes/Wabi` (rebuilds then apply without copying):

```powershell
cmd /c mklink /J "<vault>\.obsidian\themes\Wabi" "<repo>\ports\obsidian"
```

On macOS / Linux: `ln -s "<repo>/ports/obsidian" "<vault>/.obsidian/themes/Wabi"`.

Or copy `manifest.json` and `theme.css` into `<vault>/.obsidian/themes/Wabi/`.

Then open **Settings → Appearance → Themes → Manage** (or the theme dropdown), pick **Wabi**, and choose Light, Dark or "Adapt to system".

## Notes

- Don't edit `theme.css` directly: edit `palette/palette.json` or `theme.css.tmpl` and run `node generator/build.js`. Obsidian reloads the theme when the file changes; if it doesn't, switch themes and back.
- The theme only sets Obsidian's CSS variables (base scale, accent, text, links, tags, code, graph), so it stays compatible with plugins and snippets.
