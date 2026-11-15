# Creating a port

A port brings Wabi to a new app. Every port is generated from the same palette, so building one mostly means writing a **template**: the app's theme file with palette roles instead of colours.

Before starting, read the [style guide](style-guide.md): it says which role goes where.

## Requirements

A port is ready to merge when it:

- ships **both variants**, dark and light;
- is generated from a template, with **no hard-coded colours** (apart from fully transparent `#00000000`);
- follows the roles in the style guide (keywords orange, functions blue, strings green…);
- has a `README.md` with install steps;
- has been tested in the app, in both variants.

## 1. Open an issue

Open a **Port request** issue first, so nobody else builds the same port in parallel and we can agree on the approach.

## 2. Create the folder

Everything for the port goes in `ports/<app>/`, named in lowercase after the app (`ports/alacritty`, `ports/zed`). Keep the app's own file layout inside it, so the folder can be installed or published as it is:

```
ports/zed/
├── extension.toml                 # app manifest, written by hand
├── LICENSE                        # copy of the root LICENSE, if the app's registry needs one
├── README.md                      # install steps
└── themes/
    ├── wabi-{variant}.json.tmpl   # the template
    ├── wabi-dark.json             # generated
    └── wabi-light.json            # generated
```

Files that don't contain colours (manifests, READMEs) are written by hand. Only files with colours are templates.

## 3. Write the template

A template is any file ending in `.tmpl`. The generator replaces placeholders with palette values and writes the result next to it, without the `.tmpl`.

### Placeholders

| Placeholder | Output |
| --- | --- |
| `{{key}}` | The colour, e.g. `{{bg0}}` → `#1b1a18` |
| `{{key.hex}}` | Without the `#`, e.g. `1b1a18` |
| `{{key.rgb}}` | As `r, g, b`, e.g. `27, 26, 24` |
| `{{key}}33` | With opacity: any two hex digits after the placeholder (see the opacity steps in the style guide) |
| `{{name}}` | `Wabi` |
| `{{variant}}` | `dark` or `light` |
| `{{Variant}}` | `Dark` or `Light` |

`key` is any key of a variant in `palette/palette.json`. An unknown key stops the build with an error naming the file, so typos don't slip through.

### One file per variant, or one file for both

Pick the form that matches how the app loads themes.

**One file per variant**: put `{variant}` in the file name. The template is rendered once per variant.

```
wabi-{variant}.toml.tmpl  →  wabi-dark.toml, wabi-light.toml
```

Used by Alacritty, Zed and VSCode.

**One file for both variants**: leave `{variant}` out of the file name, and wrap the part that changes in an `{{#each_variant}}` block. The block is repeated once per variant; outside it only `{{name}}` is available.

```css
/* theme.css.tmpl */
{{#each_variant}}
.theme-{{variant}} {
  --background-primary: {{bg0}};
}
{{/each_variant}}
```

Used by Obsidian, which loads a single `theme.css` with both `.theme-dark` and `.theme-light`.

### Tips

- Start from the app's default theme file, or its official schema, and replace every colour with a role. Leave out keys you have no opinion on, so the app's defaults fill them.
- Prefer the semantic aliases (`{{error}}`, `{{git_added}}`) where the meaning matters.
- Validate against the app's schema if there is one. Zed and VSCode publish theirs, and the existing ports were checked against them.

## 4. Generate

```bash
node generator/build.js
```

It prints the contrast report and every file it writes. Commit **both** the template and the generated files: people install ports straight from the repo, without running the generator.

Never edit a generated file by hand; the next build overwrites it.

## 5. Test

Install the port from your working copy, so rebuilds show up quickly. What works depends on the app:

| App | How the existing port is tested |
| --- | --- |
| Alacritty | `import` the generated file straight from the repo; Alacritty reloads it live |
| Zed | **Install Dev Extension** pointing at `ports/zed` |
| VSCode / Cursor | `pwsh ports/vscode/package.ps1 -Install` builds and installs a `.vsix` |
| Obsidian | A link from `<vault>/.obsidian/themes/Wabi` to `ports/obsidian` |

Check, in **both** variants:

- [ ] Body text, comments and line numbers are readable.
- [ ] Syntax colours match the style guide (open a file in a language with rich highlighting, such as TypeScript or Rust).
- [ ] Selection, search matches and the cursor are visible.
- [ ] Errors, warnings and git changes show up in their colours.
- [ ] Popups and menus stand out from the background.
- [ ] Nothing still shows the app's default colours where Wabi should apply.

## 6. Document

- `ports/<app>/README.md`: how to install, how to switch between dark and light, and anything specific to the app. The existing ports' READMEs are good starting points.
- Add a row to the **Ports** table in the main [README](../README.md).

## 7. Open a pull request

Fill in the PR checklist, and add screenshots of both variants. Thanks for building a port!
