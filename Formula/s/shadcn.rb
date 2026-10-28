class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.22.2.tgz"
  sha256 "657fe32da117fe5743ad6e663acdf3cf596eb6d2600e51e3fcaa8b293717992b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fd4bc1c9964110f581c42b3c3b1bbe1a5b12bf8a23fef08d1882160db448858"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6fd4bc1c9964110f581c42b3c3b1bbe1a5b12bf8a23fef08d1882160db448858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6fd4bc1c9964110f581c42b3c3b1bbe1a5b12bf8a23fef08d1882160db448858"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d46465d82a4e8f3f6e43f8ba7fce9ce3fd51d2bac75210d14542c81efbc2f96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d46465d82a4e8f3f6e43f8ba7fce9ce3fd51d2bac75210d14542c81efbc2f96c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
