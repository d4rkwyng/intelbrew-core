class LimaAdditionalGuestagents < Formula
  desc "Additional guest agents for Lima"
  homepage "https://lima-vm.io/"
  url "https://github.com/lima-vm/lima/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "436ace830cb3e8fa512e0157a220bd8d6f826aef789c3f26d2984f0ea1e3c2ea"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/lima-additional-guestagents-2.3.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "75075dc1d13e0b03a30b731879e2c72f445b45038c7984b01f1529fb09607ad6"
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
