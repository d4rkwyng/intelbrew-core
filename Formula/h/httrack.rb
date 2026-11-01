class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.51.0/httrack-3.51.0.tar.gz"
  sha256 "1daa7ec0153ec16e6bea809c2d8829ceddf0e06f74471fa0528ffbf20275f5f1"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/httrack-3.51.0"
    rebuild 1
    sha256 sonoma: "d33ba6de817f621e4585eec5b5975e695fd93971a48bd32521563e87fac627bc"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Gnome integration is inert on macOS, but Linux desktops use it
    rm_r(Dir["#{share}/{applications,pixmaps,icons,metainfo}"]) if OS.mac?
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end
