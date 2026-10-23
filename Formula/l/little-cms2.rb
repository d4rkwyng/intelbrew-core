class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.19.1/lcms2-2.19.1.tar.gz"
  sha256 "bfc54f7bab59fbc921012014a8032e4cba4abd46db47d46b76416a8c0b2815c8"
  license "MIT"
  version_scheme 1
  compatibility_version 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(/Little\s*CMS\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/little-cms2-2.19.1"
    rebuild 2
    sha256 cellar: :any, sonoma: "c5c5038e223a18f5ee9e5879b46037a892a19089d05861c187631da04ac2da62"
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/lcms2.pc", prefix, opt_prefix
  end

  test do
    system bin/"jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
