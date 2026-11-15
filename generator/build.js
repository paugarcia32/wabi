#!/usr/bin/env node
// Renders every `*.tmpl` file under ports/ from the palette.
//
//   {{key}}        -> colour value from the variant, e.g. "#1b1a18"
//   {{key.hex}}    -> colour without the leading "#", e.g. "1b1a18"
//   {{key.rgb}}    -> colour as "r, g, b", e.g. "27, 26, 24"
//   {{variant}}    -> variant id, e.g. "dark"
//   {{Variant}}    -> capitalised variant id, e.g. "Dark"
//   {{name}}       -> palette name, e.g. "Wabi"
//
// Two kinds of template:
//
// - "{variant}" in the file name: rendered once per variant, output next to
//   the template with ".tmpl" removed and "{variant}" replaced:
//     ports/alacritty/wabi-{variant}.toml.tmpl -> ports/alacritty/wabi-dark.toml
//
// - no "{variant}" in the file name: rendered once into a single file. Text
//   between {{#each_variant}} and {{/each_variant}} is repeated for every
//   variant with that variant's colours; outside it only {{name}} is known:
//     ports/obsidian/theme.css.tmpl -> ports/obsidian/theme.css
//
// Usage: node generator/build.js [--check]
//   --check  only print the contrast report, don't write files

const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const palette = JSON.parse(fs.readFileSync(path.join(root, "palette", "palette.json"), "utf8"));

function findTemplates(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((e) => {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) return findTemplates(p);
    return e.name.endsWith(".tmpl") ? [p] : [];
  });
}

function render(text, vars, file) {
  return text.replace(/\{\{\s*(\w+)(?:\.(hex|rgb))?\s*\}\}/g, (_, key, mod) => {
    if (!(key in vars)) throw new Error(`${path.relative(root, file)}: unknown key "{{${key}}}"`);
    const v = vars[key];
    if (mod === "hex") return v.replace(/^#/, "");
    if (mod === "rgb") return [1, 3, 5].map((i) => parseInt(v.slice(i, i + 2), 16)).join(", ");
    return v;
  });
}

function variantVars(id, colours) {
  return {
    ...Object.fromEntries(Object.entries(colours).filter(([k]) => !k.startsWith("_"))),
    name: palette.name,
    variant: id,
    Variant: id[0].toUpperCase() + id.slice(1),
  };
}

// WCAG 2 contrast ratio
function luminance(hex) {
  const [r, g, b] = [1, 3, 5]
    .map((i) => parseInt(hex.slice(i, i + 2), 16) / 255)
    .map((c) => (c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4));
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}
function contrast(a, b) {
  const [hi, lo] = [luminance(a), luminance(b)].sort((x, y) => y - x);
  return (hi + 0.05) / (lo + 0.05);
}

const TEXT_KEYS = ["fg0", "fg", "fg1", "fg2", "comment", "orange", "red", "yellow", "green", "aqua", "blue", "purple"];
const MIN_CONTRAST = 4.5;

let failed = false;
for (const [id, colours] of Object.entries(palette.variants)) {
  console.log(`\n${palette.name} ${id} — contrast against bg0 (${colours.bg0})`);
  for (const k of TEXT_KEYS) {
    const ratio = contrast(colours[k], colours.bg0);
    const ok = ratio >= MIN_CONTRAST;
    if (!ok) failed = true;
    console.log(`  ${ok ? "ok  " : "LOW "} ${k.padEnd(8)} ${colours[k]}  ${ratio.toFixed(2)}`);
  }
}

if (process.argv.includes("--check")) process.exit(failed ? 1 : 0);

const templates = findTemplates(path.join(root, "ports"));
console.log("");
for (const tmpl of templates) {
  const source = fs.readFileSync(tmpl, "utf8");
  const base = tmpl.slice(0, -".tmpl".length);

  if (path.basename(tmpl).includes("{variant}")) {
    for (const [id, colours] of Object.entries(palette.variants)) {
      const out = base.replace("{variant}", id);
      fs.writeFileSync(out, render(source, variantVars(id, colours), tmpl));
      console.log(`wrote ${path.relative(root, out)}`);
    }
    continue;
  }

  const expanded = source.replace(/\{\{#each_variant\}\}([\s\S]*?)\{\{\/each_variant\}\}/g, (_, block) =>
    Object.entries(palette.variants)
      .map(([id, colours]) => render(block, variantVars(id, colours), tmpl))
      .join("")
  );
  fs.writeFileSync(base, render(expanded, { name: palette.name }, tmpl));
  console.log(`wrote ${path.relative(root, base)}`);
}
