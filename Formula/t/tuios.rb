class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.dev/"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "11803b70c1853c8d328cf24f75ba49e0459c8589d2deb6279c52160865b69228"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/tuios-0.12.1"
    sha256 cellar: :any_skip_relocation, sonoma: "10213c171c890a33cf80c646b2aab6ba581a44ed3c057d2d3e4c0ecdf86633d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
