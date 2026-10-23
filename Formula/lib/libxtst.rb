class Libxtst < Formula
  desc "X.Org: Client API for the XTEST & RECORD extensions"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libXtst-1.2.6.tar.gz"
  sha256 "f30f2d4f8370077de9f35220a539bf34c042ca02a55669a4d8f345c661ce7839"
  license "MIT"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/libxtst-1.2.6"
    rebuild 1
    sha256 cellar: :any, sonoma: "9ef760712af29e2d7200817c5492dd7b3936ee636a34d35595a85fbecaf552de"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/extensions/record.h"

      int main(int argc, char* argv[]) {
        XRecordRange8 *range;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
