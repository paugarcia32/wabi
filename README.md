# wabi

A minimal, calm and warm colour theme. Named after *wabi-sabi*: quiet, imperfect simplicity.

Warm neutrals inspired by the Anthropic brand colours, a clay orange as the signature accent, and muted supporting colours — with Gruvbox and Monokai as references.

## Palette (dark)

| Role | Hex | | Role | Hex |
| --- | --- | --- | --- | --- |
| `bg_dim` | `#141413` | | `orange` | `#d97757` |
| `bg0` | `#1b1a18` | | `red` | `#d16a6f` |
| `bg1` | `#23221f` | | `yellow` | `#d5a65e` |
| `bg2` | `#2e2c28` | | `green` | `#99a874` |
| `bg3` | `#3b3934` | | `aqua` | `#82aa9c` |
| `bg4` | `#4d4a44` | | `blue` | `#7fa3cc` |
| `fg` | `#e8e6dc` | | `purple` | `#ae92b8` |
| `fg0` | `#faf9f5` | | `fg1` | `#c8c5b9` |
| `fg2` | `#a19e94` | | `comment` | `#8a877d` |

## Palette (light)

| Role | Hex | | Role | Hex |
| --- | --- | --- | --- | --- |
| `bg_dim` | `#efede4` | | `orange` | `#ab5134` |
| `bg0` | `#faf9f5` | | `red` | `#b0464f` |
| `bg1` | `#f2f0e8` | | `yellow` | `#8f661c` |
| `bg2` | `#e8e6dc` | | `green` | `#5c703e` |
| `bg3` | `#dcd9cd` | | `aqua` | `#3d7566` |
| `bg4` | `#c9c5b8` | | `blue` | `#3e6b99` |
| `fg` | `#2b2a27` | | `purple` | `#7c5c8c` |
| `fg0` | `#141413` | | `fg1` | `#45433e` |
| `fg2` | `#5f5c55` | | `comment` | `#6d6a63` |

In both variants, all text colours meet WCAG AA (≥ 4.5:1) against `bg0`.

## Ports

| Platform | Status |
| --- | --- |
| [Alacritty](ports/alacritty) | ✅ |
| Nvim | planned |
| VSCode / Cursor | planned |
| Zed | planned |
| Obsidian | planned |

## Structure

```
palette/palette.json   single source of truth
generator/build.js     renders every ports/**/*.tmpl from the palette
ports/<platform>/      one folder per platform
preview/               screenshots and sample files
```

## Development

Requires Node.js.

```bash
node generator/build.js          # contrast report + regenerate all ports
node generator/build.js --check  # contrast report only
```

Never edit generated files by hand: change `palette/palette.json` or a `.tmpl` template and rebuild.
