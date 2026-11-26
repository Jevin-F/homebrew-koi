cask "koi" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.1"
  sha256 arm:   "bbedd3b7d3d3b9675b78359ab6eb90375bdb8117905c9aa98a4bc6d4afdd3ee7",
         intel: "add87894cbe6b5e2432003f9076469ea4e0ab50a6356e4aa71e71e93dcf77977"

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
