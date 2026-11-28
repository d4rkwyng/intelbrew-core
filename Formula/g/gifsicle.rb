class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.99.tar.gz"
  sha256 "c21a01f670a336f5412b1870e5a6c241252a3408a3e699d216d58bd41011ae06"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?gifsicle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/gifsicle-1.99"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "436d76eecae67de0829fb556e184ab596283ce7bf466fa512cdc3a0e0d1ba80f"
  end

  head do
    url "https://github.com/kohler/gifsicle.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-gifview
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gifsicle", "--info", test_fixtures("test.gif")
  end
end
