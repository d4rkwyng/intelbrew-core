class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.1.tar.gz"
  sha256 "a9cb3f5cac1c0d22df189117df8d78fa3d7e9fdcd83fb5b6ab1f0b66c8835a55"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ast-grep-0.51.1"
    sha256 cellar: :any_skip_relocation, sonoma: "a4eacb4622ab99a5733460ce8334ae39e2310008bf59b3efb4a72b348917ddab"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
