class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.24.0.tar.gz"
  sha256 "5ecc22f581cafe4039873e2f28e0d045efecfb0dfc6ea51ee1345daa694cb6a9"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/gopls-0.24.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "2727f77c993f51c209cac07cf7cf16f99734d716841104430e8416a698fea8d4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "gopls"
  end

  def install
    cd "gopls" do
      system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}")
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
    assert_equal "Go", output["Lenses"][0]["FileType"]
    assert_match version.to_s, shell_output("#{bin}/gopls version")
  end
end
