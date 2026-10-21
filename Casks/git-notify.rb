# frozen_string_literal: true

# Template: `make release` substitutes the version and checksum placeholders, and the Release
# workflow commits the result to MihaiLupoiu/homebrew-tap as Casks/git-notify.rb.
cask "git-notify" do
  version "0.1.0"
  sha256 "c8d36bceaa29a56fa3460b70b042ef29b8a936cb48285c399a443d35a40b7bef"

  url "https://github.com/MihaiLupoiu/git-notify-releases/releases/download/v#{version}/GitNotify.zip"
  name "GitNotify"
  desc "Menu-bar app for GitHub pull requests waiting on your review"
  homepage "https://github.com/MihaiLupoiu/git-notify-releases"

  # Signs in through the GitHub CLI's login until Sign in with GitHub exists.
  depends_on formula: "gh"
  depends_on macos: :sonoma

  app "GitNotify.app"

  # The app is signed ad hoc, not with a Developer ID, so Gatekeeper refuses to open a downloaded
  # copy. Clear the quarantine flag on the unpacked app before it is moved to /Applications.
  preflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "GitNotify.app"], chdir: "."
  end

  uninstall quit: "com.github.mihailupoiu.GitNotify"

  zap trash: [
    "~/.config/git-notify",
    "~/Library/Application Support/git-notify",
  ]

  caveats <<~EOS
    GitNotify uses the GitHub CLI's login. If you haven't already:
      gh auth login
  EOS
end
