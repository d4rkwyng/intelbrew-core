class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "aca55758bc63aacbbb201aaeec618718aea70c10d65d97f5ec540bf3cb2c90a1"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/hunk-0.25.0"
    sha256 cellar: :any_skip_relocation, sonoma: "a33763abf8a1f7a1ef9317b47a2d7fd14696564133755e011404171e2b0fe47a"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    system "bun", "run", "build:bin", "--runtime-executable", formula_opt_bin("bun")/"bun"
    libexec.install "dist/hunk", "dist/skills"
    (bin/"hunk").write_env_script libexec/"hunk", HUNK_INSTALL_SOURCE: "homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hunk --version")

    help_output = shell_output("#{bin}/hunk --help")
    assert_match("hunk diff", help_output)
    assert_match("hunk skill path", help_output)

    skill_path = shell_output("#{bin}/hunk skill path").strip
    assert_match(/SKILL\.md\z/, skill_path)
    assert_path_exists skill_path, "hunk skill path did not resolve to a bundled skill file: #{skill_path}"
  end
end
