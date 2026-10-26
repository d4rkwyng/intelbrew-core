class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://github.com/gastownhall/beads/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d2969ec18f4754dee4f08cb05a0d978dfcca750aa6db9a72b3f35ef3cd62dcc9"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/beads-1.3.2_1"
    sha256 cellar: :any, sonoma: "260185e949f53036cb6cbd0203c264fc1bcc7502462faeb649c54cfbf0fe3500"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@79"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end
