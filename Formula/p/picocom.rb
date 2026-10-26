class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://gitlab.com/wsakernel/picocom"
  url "https://gitlab.com/wsakernel/picocom/-/archive/2024-07/picocom-2024-07.tar.gz"
  sha256 "4379de2ec591a5848123f37ccdbc7fbeee6dd3520ef1ce4119d84202fc268a17"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/picocom-2024-07"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "f4ee34a7ad7de0817a0549c8a4427a07625a12290c99c01fa754b31e024f89bb"
  end

  depends_on "go-md2man" => :build

  def install
    system "make", "all", "doc"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system bin/"picocom", "--help"
  end
end
