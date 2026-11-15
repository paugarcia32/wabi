# Wabi for Alacritty

## Install

1. Copy `wabi-dark.toml` to your Alacritty config folder:
   - Windows: `%APPDATA%\alacritty\`
   - macOS / Linux: `~/.config/alacritty/`
2. Import it in `alacritty.toml`:

   ```toml
   [general]
   import = ["~/.config/alacritty/wabi-dark.toml"]
   ```

   On Windows use the full path, e.g. `"C:/Users/<you>/AppData/Roaming/alacritty/wabi-dark.toml"`.

Requires Alacritty 0.13+ (TOML config). On versions before 0.14, put `import` at the top level instead of under `[general]`.

## Notes

- Orange has no ANSI slot, so it's mapped to indexed colour **16** (bright orange on **17**).
- Don't edit `wabi-dark.toml` directly — edit `palette/palette.json` or the `.tmpl` file and run `node generator/build.js`.
