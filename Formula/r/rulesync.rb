class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-43.1.2.tgz"
  sha256 "36799481ae3f44ecd7023dbf79c1e2c6dda7d77cf5829c235f0e2dd20f56f145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a18ff3ac0507a26f94cbf48880d2704467e3eed9d1ba54c98c9421ea48e90ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a18ff3ac0507a26f94cbf48880d2704467e3eed9d1ba54c98c9421ea48e90ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a18ff3ac0507a26f94cbf48880d2704467e3eed9d1ba54c98c9421ea48e90ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7913cbc13272e9397b3a94258d4eb25a9cd890aa72ca768d264526128daa5bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7913cbc13272e9397b3a94258d4eb25a9cd890aa72ca768d264526128daa5bc0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
