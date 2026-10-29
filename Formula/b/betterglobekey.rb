class Betterglobekey < Formula
  desc "Reworked Globe key for faster input source switching"
  homepage "https://github.com/Serpentiel/betterglobekey"
  url "https://github.com/Serpentiel/betterglobekey/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "427e6766cf8d1971ba5cc371a678c31ef8a14ec49660bc7eb28acc4c03f04e35"
  license "MIT"
  head "https://github.com/Serpentiel/betterglobekey.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd2eed105fc5b4f80d798165eb10167c3eae33f41abda9909932ac6e39969ae2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4175fc3cc047b8142733b1d5c178b12557615f11b2a13eb618a0d02295709dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41920f344cb3be25f1458e461626f167dc2f31527263893d9feddf45386e145b"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"betterglobekey", "completion")
  end

  service do
    run opt_bin/"betterglobekey"
    keep_alive true
    log_path var/"log/betterglobekey.log"
    error_log_path var/"log/betterglobekey.log"
  end

  test do
    list = shell_output("#{bin}/betterglobekey list")
    assert_match(/^com\.apple\.keylayout\./, list)
  end
end
