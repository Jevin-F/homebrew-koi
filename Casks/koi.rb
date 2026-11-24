cask "koi" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.0"
  sha256 arm:   "9ba1e4810491f18ff1319d8eb749a51527f87cde2aeffbd2b4249db0b12d3a92",
         intel: "fee9ff393f5ef71b6a6367ab489b2feb84034404012725c6dda21bcbe0811105"

  url "https://github.com/Jevin-F/koi/releases/download/v#{version}/Koi-#{version}-#{arch}.dmg"
  name "Koi"
  desc "Run and watch many CLI coding agents from one window"
  homepage "https://github.com/Jevin-F/koi"

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
