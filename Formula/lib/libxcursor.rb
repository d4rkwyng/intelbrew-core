class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXcursor-1.2.3.tar.xz"
  sha256 "fde9402dd4cfe79da71e2d96bb980afc5e6ff4f8a7d74c159e1966afb2b2c2c0"
  license "MIT"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/libxcursor-1.2.3"
    rebuild 1
    sha256 cellar: :any, sonoma: "f2288d0084d4ab14d3e1e02f3b147de15b2f9538d66965e50ac885242c0af8b2"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

  deny_network_access!

  def install
    args = %W[
      --datadir=#{HOMEBREW_PREFIX}/share
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # Workaround to allow brew to record binary_relocation_files as directory needs to exist
    (share/"icons").mkpath
    touch share/"icons/.keepme.#{name}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
