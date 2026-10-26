class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.4.0/scummvm-2026.4.0.tar.xz"
  sha256 "cd660b34104da7f85ed0a11b7c6c2320c629bb87ee297935711ebc1e09731f12"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/scummvm-2026.4.0"
    rebuild 1
    sha256 sonoma: "a0dfd2af1692b2733c9ddff27aa17f15db5cb3d36a488a17c27feb86041132fd"
  end

  depends_on "pkgconf" => :build
  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl3"
  depends_on "theora"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{formula_opt_prefix("sdl3")}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
