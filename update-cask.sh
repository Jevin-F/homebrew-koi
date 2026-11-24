#!/bin/sh
# Points Casks/koi.rb at a release of Jevin-F/koi and records its checksums.
# Usage: ./update-cask.sh [version]   (defaults to the latest release)
set -eu
cd "$(dirname "$0")"

repo=Jevin-F/koi
tag=${1:+v${1#v}}
tag=${tag:-$(gh release view --repo "$repo" --json tagName --jq .tagName)}
version=${tag#v}

# GitHub records each asset's SHA-256, so nothing needs downloading.
digest() {
    sum=$(gh api "repos/$repo/releases/tags/$tag" \
        --jq ".assets[] | select(.name == \"$1\") | .digest")
    case "$sum" in
        sha256:*) echo "${sum#sha256:}" ;;
        *) echo "No SHA-256 recorded for $1 in $tag" >&2; exit 1 ;;
    esac
}
arm=$(digest "Koi-$version-arm64.dmg")
intel=$(digest "Koi-$version-x86_64.dmg")

mkdir -p Casks

cat > Casks/koi.rb <<CASK
cask "koi" do
  arch arm: "arm64", intel: "x86_64"

  version "$version"
  sha256 arm:   "$arm",
         intel: "$intel"

  url "https://github.com/$repo/releases/download/v#{version}/Koi-#{version}-#{arch}.dmg"
  name "Koi"
  desc "Run and watch many CLI coding agents from one window"
  homepage "https://github.com/$repo"

  depends_on macos: :ventura

  app "Koi.app"

  # Koi is ad-hoc signed and not notarized, so Gatekeeper would refuse to
  # open it while the download's quarantine flag is set.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Koi.app"],
        writable_paths: ["Koi.app"],
        writable_base:  :appdir
  end

  zap trash: "~/Library/Application Support/Koi"
end
CASK
echo "Casks/koi.rb now points at $tag"
