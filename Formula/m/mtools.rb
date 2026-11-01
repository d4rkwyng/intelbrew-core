class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftpmirror.gnu.org/mtools/mtools-4.0.50.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mtools/mtools-4.0.50.tar.gz"
  sha256 "7f078accae7551c6b3a316ccd8296357329f7bbbc09583dcd1a2bbaeb081a7a4"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/mtools-4.0.50"
    sha256 cellar: :any_skip_relocation, sonoma: "729a3fc592a14fb2cf5d200c160ba11b639f71593fe2356756ecd3c5a4a2396c"
  end

  conflicts_with "mcat", because: "both install `mcat` binaries"
  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  deny_network_access!

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]
    args << "LIBS=-liconv" if OS.mac?

    # The mtools configure script incorrectly detects stat64. This forces it off
    # to fix build errors on Apple Silicon. See stat(6) and pv.rb.
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtools --version")
  end
end
