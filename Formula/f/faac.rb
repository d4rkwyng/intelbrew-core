class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://freewareadvancedaudio.github.io"
  url "https://github.com/FreewareAdvancedAudio/faac/archive/refs/tags/faac-2.2.tar.gz"
  sha256 "a93963573907c83e26e8cfabbf80d3a9c360f06ea4ecf1ea6cb74a202494d8d9"
  license "LGPL-2.1-or-later"
  compatibility_version 3
  head "https://github.com/FreewareAdvancedAudio/faac.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/faac-2.2"
    rebuild 1
    sha256 cellar: :any, sonoma: "6105c349ef6bd21153a7e6495cc3589bc7e089b2c7a4ccb75877d250d0ca8b42"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end
