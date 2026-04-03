cask "veil" do
  version "0.5"
  sha256 "9e2363de2f85f0e2ec8c7ade95214eec7134f471ccc5a79cbcfa4e2c7fdd5a3a"

  url "https://github.com/rainux/Veil/releases/download/v#{version}/Veil.zip"
  name "Veil"
  desc "A quiet, vanilla Neovim GUI for macOS"
  homepage "https://github.com/rainux/Veil"

  depends_on macos: ">= :sonoma"

  app "Veil.app"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Veil.app"]
  end

  binary "#{appdir}/Veil.app/Contents/bin/veil"
  binary "#{appdir}/Veil.app/Contents/bin/gvim", target: "gvim"
  binary "#{appdir}/Veil.app/Contents/bin/gvimdiff", target: "gvimdiff"

  zap trash: [
    "~/Library/Preferences/org.1b2c.Veil.plist",
  ]
end
