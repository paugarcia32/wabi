# Contributing to Wabi

Thanks for wanting to help! Wabi is a small project, so contributions of any size are welcome: fixing a colour in a port, improving docs, or adding a port for a new app.

By taking part you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## How the repo works

```
palette/palette.json   every colour, for every variant: the single source of truth
generator/build.js     renders every ports/**/*.tmpl from the palette
ports/<app>/           one folder per app: templates, generated files, README
```

**Never edit generated files by hand.** Change `palette/palette.json` or a port's `.tmpl` template, then rebuild:

```bash
node generator/build.js          # contrast report + regenerate all ports
node generator/build.js --check  # contrast report only (fails if a text colour is below 4.5:1)
```

Only Node.js is needed; there are no dependencies to install.

## Reporting a problem

Open an issue with the **Bug report** template. Include the app and its version, the variant (dark or light), and a screenshot if you can.

## Suggesting a port

Open an issue with the **Port request** template first, so we can check nobody else is working on it.

## Making a change

1. Fork the repo and create a branch: `fix/<port>-<what>` or `feat/<port>-port`.
2. Make your change in the palette or the templates, and run `node generator/build.js`.
3. Commit both the template and the generated files.
4. Test the result in the app, in **both** the dark and light variants.
5. Open a pull request and fill in the checklist. Screenshots of both variants help a lot.

### Adding a port

- Put everything in `ports/<app>/`.
- Use palette roles, not raw hex values, so the port follows palette changes.
- Follow the same roles as the other ports: keywords orange, functions blue, strings green, types yellow, constants purple, comments in the comment colour.
- Add a `README.md` with install steps, and a row in the ports table of the main README.

## Palette changes

Changes to `palette/palette.json` affect every port, so open an issue to discuss them first. Text colours must keep at least 4.5:1 contrast against `bg0`.
