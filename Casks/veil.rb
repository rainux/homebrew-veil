cask "veil" do
  version "0.6.3"
  sha256 "fb39219fa241fd92473625d04d531af4cabe20f1bf7cbf78b57f0e0fabd519ac"

  url "https://github.com/rainux/Veil/releases/download/v#{version}/Veil.zip"
  name "Veil"
  desc "A Neovim GUI built for efficiency, not for cool"
  homepage "https://github.com/rainux/Veil"

  depends_on macos: ">= :sonoma"

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
