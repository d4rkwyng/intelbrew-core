class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://ast-grep.github.io/"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.51.3.tar.gz"
  sha256 "2a40a15fe439f24e24a88d2dd0bd3433a47bbd5032d43f6a4aa2522e397e8def"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ast-grep-0.51.3"
    sha256 cellar: :any_skip_relocation, sonoma: "78def1ddd770ad1efc789bda05097971f0c96ab08c43c6e3fd0ce5836b4fb441"
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
