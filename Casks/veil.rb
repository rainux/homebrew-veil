cask "veil" do
  version "0.8.1"
  sha256 "9859e33906eda7354e75a7f7b948eb17d8dae47eba1c34f2ad86fafb73bab878"

  url "https://github.com/0x1b2c/Veil/releases/download/v#{version}/Veil.zip"
  name "Veil"
  desc "A Neovim GUI built for efficiency, not for cool"
  homepage "https://github.com/0x1b2c/Veil"

  conflicts_with cask: "veil-default-editor"

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
