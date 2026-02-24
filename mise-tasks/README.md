# Mise file-based tasks

Scripts here are discovered by [mise](https://mise.jdx.dev/) as tasks (e.g. `mise run test:unit`).

**When adding a new task:** make the file executable so mise discovers it and CI works:

```bash
chmod +x mise-tasks/<namespace>/<task>
# or when adding: git add --chmod=+x mise-tasks/<path>
```
