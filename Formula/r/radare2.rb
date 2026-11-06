class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.2.6.tar.gz"
  sha256 "ef5ae9a0785be28ff38ea61e3b1351232c068691868bab98613c67a8b7aa4872"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/radare2-6.2.6"
    sha256 sonoma: "25be8d56457b13754b08dc3e24402ca7933b75872f1e7f922ce71ee81e3d8098"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
