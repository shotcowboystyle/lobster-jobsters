# skills/

Third-party skills are **not vendored** in this repository. They are pinned in `../.clawhub/lock.json` (version + artifact sha256 + `SKILL.md` sha256) and installed into this directory at deploy time:

```bash
clawhub install          # reads ../.clawhub/lock.json
```

Review a skill's `SKILL.md` before installing it — a skill is a prompt, and prompts instruct agents. Installed skill directories are git-ignored (`**/skills/*/`).
