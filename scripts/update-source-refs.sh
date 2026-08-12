#!/bin/bash
# This script updates plugins.json for each unique sourceUrl.
# It sets sourceRef to the newest commit on the default branch.
# It sets version to the date of that commit.
# It does not change binaryUrl or sha256. A release updates those fields.
set -euo pipefail

cd "$(dirname "$0")/.."

for url in $(jq -r '[.plugins[].sourceUrl] | unique | .[]' plugins.json); do
  ref=$(git ls-remote "$url.git" HEAD | cut -f1)
  repo=${url#https://github.com/}
  version=$(gh api "repos/$repo/commits/$ref" \
    --jq '.commit.committer.date[:10]' | tr '-' '.')
  jq --arg url "$url" --arg ref "$ref" --arg version "$version" \
    '(.plugins[] | select(.sourceUrl == $url)) |= (.sourceRef = $ref | .version = $version)' \
    plugins.json > plugins.json.tmp
  mv plugins.json.tmp plugins.json
  echo "$repo: $ref ($version)"
done
