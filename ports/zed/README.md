# Wabi for Zed

Two themes: **Wabi Dark** and **Wabi Light**.

## Install (from this repo)

1. Open Zed and run `zed: install dev extension` from the command palette (or the **Install Dev Extension** button on the Extensions page).
2. Select the `ports/zed` folder of this repo.
3. Run `theme selector: toggle` and pick **Wabi Dark** or **Wabi Light**.

To follow the system light/dark mode, set this in your Zed `settings.json`:

```json
"theme": {
  "mode": "system",
  "dark": "Wabi Dark",
  "light": "Wabi Light"
}
```

## Notes

- Don't edit `themes/wabi-*.json` directly: edit `palette/palette.json` or `themes/wabi-{variant}.json.tmpl` and run `node generator/build.js`. After rebuilding, run `zed: rebuild dev extension` (or reinstall it) to see the changes.
- Theme keys follow Zed's schema `v0.2.0`.
