class Powerlevel10k < Formula
  desc "Theme for zsh"
  homepage "https://github.com/romkatv/powerlevel10k"
  url "https://github.com/romkatv/powerlevel10k/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "352e277a60dbdda0a2005758b0c20b35e04a315b98f06bb8a75ef649e9b8c881"
  license "MIT"
  head "https://github.com/romkatv/powerlevel10k.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/powerlevel10k-1.21.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "28e653fc3f4b7cbb8d925f4b782f1d72c400a56c51cbf110a977816b331f20dc"
  end

  uses_from_macos "zsh" => :test

  def install
    system "make", "pkg"
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate this theme, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    output = shell_output("zsh -fc '. #{pkgshare}/powerlevel10k.zsh-theme && (( ${+P9K_SSH} )) && echo SUCCESS'")
    assert_match "SUCCESS", output
  end
end
