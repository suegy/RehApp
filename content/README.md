# Content Source

This folder contains editable application and module content. It is deliberately outside `lib/` so authors and translators can work without editing Flutter widgets.

## Layout

```text
content/
  locales/
    sv.json
    en.json
  modules.json
  modules/
    <module-key>/
      sv.md
      en.md
```

`locales/<locale>.json` holds application UI labels, validation messages, and module-list labels. `modules.json` defines the ordered home-path modules with stable IDs, state, and the locale keys for their title and description. Each module's authored text is a Markdown file in `modules/<module-key>/<locale>.md`.

Use a stable, lowercase module key, for example `core`. Add a translation by copying the Markdown file and translating its textual content. Keep the heading sequence aligned between translations.

## Authoring rules

- Keep each module `id` in `modules.json` unchanged once content is published.
- Use standard Markdown headings, paragraphs, lists, links, emphasis, and quotes in module files.
- Use `TODO:` only when editorial content or a media reference has not been supplied.
- Replace every `TODO:` value before production import.
- Do not add real personal or clinical user data to source content.

## Planned import

A future content-import command will validate these JSON and Markdown files and upsert the module, blocks, and localized content records into PocketBase. The current Flutter visual shell reads these files directly; production will retrieve the published records from PocketBase.
