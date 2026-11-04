class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.15.0.tar.gz"
  sha256 "f0eb9da1fa3de3fb250ff0045a12372709a4b005096f8d0becfdc6cb099323a8"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/topgrade-17.15.0"
    sha256 cellar: :any_skip_relocation, sonoma: "5144f616dcaf63660c6b7ed02809d62cf5d9f91ef218399bcd9b3e2c9e273b10"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
