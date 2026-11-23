class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "b20afecb54a7ddaa12bc931ae081bf0e017c163ceb7d14bfcd571a286741ccd2"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/carapace-1.8.4"
    sha256 cellar: :any_skip_relocation, sonoma: "e1572c2311e3923d5f8844a6026cf0516eaf1c4082f03ca209839a0fd5eb2032"
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
