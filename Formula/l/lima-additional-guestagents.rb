class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d551efb52115ba006c1052d5c929e4d3afac363c78c9cfca6975af1f85c1426a"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/lima-additional-guestagents-2.2.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "28068906f280fe5ec3b251b5b6e5aec8c4c40d2c8e54e32d8ac23ddb9ed7c382"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on "qemu"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    if build.head?
      system "make", "additional-guestagents"
    else
      # VERSION has to be explicitly specified when building from tar.gz, as it does not contain git tags
      system "make", "additional-guestagents", "VERSION=#{version}"
    end

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]
  end

  test do
    info = JSON.parse shell_output("limactl info")
    assert_includes info["guestAgents"], "riscv64"
  end
end
