class Yara < Formula
  desc "Malware identification and classification tool"
  homepage "https://virustotal.github.io/yara/"
  url "https://github.com/VirusTotal/yara/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "61ab80084e3f83e1b73a95057058e2ae1db5f87f291e32654e191d410297f0e5"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/VirusTotal/yara.git", branch: "master"

  # Upstream sometimes creates releases that use a stable tag (e.g., `v1.2.3`)
  # but are labeled as "pre-release" on GitHub, so it's necessary to use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/yara-4.6.0"
    sha256 cellar: :any, sonoma: "479aa8b770620ed1460d67715a0a64a08a48fa8cf81c4f2d42024d5cfda49543"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "openssl@4"
  depends_on "protobuf-c"

  deny_network_access!

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--enable-dotnet",
                          "--enable-cuckoo",
                          "--enable-magic",
                          "--enable-macho",
                          "--enable-dex",
                          "--with-crypto",
                          *std_configure_args
    system "make", "install"
  end

  test do
    rules = testpath/"commodore.yara"
    rules.write <<~YARA
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    YARA

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal "chrout #{program}", shell_output("#{bin}/yara #{rules} #{program}").strip
  end
end
