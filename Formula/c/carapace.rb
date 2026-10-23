class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "1dc7314cbda4643186bcf00b6e2402002a113b09a0220e5d564a40e77daa886e"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/carapace-1.8.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "808198830fcf0efcbccee16ff4913f265b8a8c6eb790a0775e15ff2a8497a60a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "generate", "./..."
    ldflags = %W[-X main.version=#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
