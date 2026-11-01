class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://github.com/transmission/transmission/releases/download/4.1.4/transmission-4.1.4.tar.xz"
  sha256 "86e7aa020cdf64826447034bc85f4d3b7c848d8c0891d9dc9b9fddfb2c805d22"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/transmission-cli-4.1.4"
    rebuild 1
    sha256 sonoma: "3cf65c708cef128ade2d21a75f39728a1a211ff06659a8590871f7078da44fb2"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libpsl"
  depends_on "miniupnpc"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      -DENABLE_CLI=ON
      -DENABLE_DAEMON=ON
      -DENABLE_GTK=OFF
      -DENABLE_MAC=OFF
      -DENABLE_NLS=OFF
      -DENABLE_QT=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_UTILS=ON
      -DENABLE_WEB=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"transmission").mkpath
  end

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      Transmission.app can be downloaded directly from the website:
        https://www.transmissionbt.com/

      Alternatively, install with Homebrew Cask:
        brew install --cask transmission
    EOS
  end

  service do
    run [opt_bin/"transmission-daemon", "--foreground", "--config-dir", var/"transmission/", "--log-info",
         "--logfile", var/"transmission/transmission-daemon.log"]
    keep_alive true
  end

  test do
    system bin/"transmission-create", "-o", testpath/"test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end
