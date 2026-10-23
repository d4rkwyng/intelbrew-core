class Graphicsmagick < Formula
  desc "Image processing tools collection"
  homepage "https://graphicsmagick.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.49/GraphicsMagick-1.3.49.tar.xz"
  sha256 "7efa070dc31116b4315061b39f84bc7181e8b060bf61214ec9af851131af9c81"
  license "MIT"
  compatibility_version 1
  head "http://hg.code.sf.net/p/graphicsmagick/code", using: :hg

  livecheck do
    url "https://sourceforge.net/projects/graphicsmagick/rss?path=/graphicsmagick"
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/graphicsmagick-1.3.49"
    rebuild 1
    sha256 sonoma: "5809f34d5220d8f57c5d1a51a9c990a1e6bab0187ade8eba207849d2afed2fcd"
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean :la

  def install
    args = %W[
      --disable-openmp
      --disable-static
      --enable-shared
      --with-modules
      --with-quantum-depth=16
      --without-lzma
      --without-x
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-wmf
      --with-jxl
    ]
    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "PNG 8x8+0+0", shell_output("#{bin}/gm identify #{fixture}")
  end
end
