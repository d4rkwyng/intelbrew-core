class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "78e7dbfcc2c8975c143a9746b073a3af875cdee72819bc383fbd411bae2c553c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/tealdeer-1.9.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "90ae05a39d8769a21aca3cd047192ae11fc711114e67c6dde609f6bdec94f2dc"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"

  # `test do` block downloads the tldr pages cache
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completion/bash_tealdeer" => "tldr"
    zsh_completion.install "completion/zsh_tealdeer" => "_tldr"
    fish_completion.install "completion/fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
