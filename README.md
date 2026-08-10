# adium-plugins-catalog

This repository is the plugin catalog for AdiumSwift. The app downloads
`plugins.json` and shows the entries in Preferences > Plugins. The app also
bundles a fallback copy of the catalog for offline use.

## How the catalog works

- `plugins.json` lists each plugin: metadata, a pinned upstream source ref,
  and (after a release) a `binaryUrl` plus a `sha256` checksum.
- The app installs a plugin only when `binaryUrl` and `sha256` are set. It
  verifies the checksum before it copies the binary.
- The CI workflow builds every plugin from its pinned `sourceRef` on an
  Apple Silicon runner and attaches the `.so` files to a GitHub Release.
  One matrix job per plugin runs the build recipe at `recipes/<id>.sh`.

## How to release binaries

1. Update `sourceRef` (and `version`) for the plugins you want to build.
2. Push a tag that matches `plugins-v*`. CI builds the plugins and creates
   a release with the `.so` files and `checksums.txt`.
3. Copy each asset URL into `binaryUrl` and each checksum into `sha256`.
4. Commit the updated `plugins.json`. The app picks it up on next launch.
5. Copy the same file into the app repo at
   `Sources/AdiumSwift/Resources/plugins-catalog.json` (bundled fallback).

## How to propose a plugin

Open a pull request that adds an entry to `plugins.json`:

- The plugin must build against libpurple 2.x on macOS arm64.
- Set `sourceUrl`, a pinned `sourceRef` (commit hash), and the license.
- Add a build recipe at `recipes/<id>.sh`. The recipe runs inside the plugin
  source checkout, installs its extra Homebrew dependencies, builds, and
  copies the `.so` files into `$DIST`.
- Leave `binaryUrl` and `sha256` as `null`. A maintainer cuts the release.

Plugins run native code with the same privileges as the app. Only curated
entries enter this catalog.
