cask "veil-default-editor" do
  version "0.8.2"
  sha256 "a8f5c4d2b352363d8b145419c3266633b08ddfa5790253ad433c7a65309bc0e1"

  url "https://github.com/0x1b2c/Veil/releases/download/v#{version}/Veil-default-editor.zip"
  name "Veil"
  desc "A Neovim GUI built for efficiency, not for cool (claims file associations)"
  homepage "https://github.com/0x1b2c/Veil"

  conflicts_with cask: "veil"

  depends_on macos: :sonoma

  app "Veil.app"

  binary "#{appdir}/Veil.app/Contents/bin/veil"

  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Veil.app"]

    {"gvim" => "gvim", "gvimdiff" => "gvimdiff"}.each do |name, target|
      bin_path = "#{HOMEBREW_PREFIX}/bin/#{target}"
      veil_source = "#{appdir}/Veil.app/Contents/bin/#{name}"

      if File.symlink?(bin_path) && File.readlink(bin_path) == veil_source
        next # already points to Veil, nothing to do
      elsif File.exist?(bin_path) || File.symlink?(bin_path)
        opoo "#{bin_path} already exists (possibly from MacVim). Skipping. To use Veil's version: ln -sf #{veil_source} #{bin_path}"
        next
      end

      File.symlink(veil_source, bin_path)
      ohai "Linking Binary '#{name}' to '#{bin_path}'"
    end
  end

  uninstall_postflight do
    ["gvim", "gvimdiff"].each do |name|
      bin_path = "#{HOMEBREW_PREFIX}/bin/#{name}"
      veil_source = "#{appdir}/Veil.app/Contents/bin/#{name}"

      File.delete(bin_path) if File.symlink?(bin_path) && File.readlink(bin_path) == veil_source
    end
  end

  zap trash: [
    "~/Library/Preferences/org.1b2c.Veil.plist",
  ]
end
