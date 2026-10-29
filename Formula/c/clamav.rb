class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  stable do
    url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.4/clamav-1.5.4.tar.gz"
    mirror "https://www.clamav.net/downloads/production/clamav-1.5.4.tar.gz"
    sha256 "1af1117a228f1b5bc7fa91a0dabc37848a99e7d25188e9be8043332ce721dfd3"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/Cisco-Talos/clamav/commit/0097a6f99d9f6b78381e12b677a38fb62242c41a.patch?full_index=1"
      sha256 "3d8d697e3d1b369836b2a3b2a4d618de682330b5c804ae655ae36a16d28f7403"
      type :backport
      resolves "https://github.com/Cisco-Talos/clamav/pull/1731"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/clamav-1.5.4_1"
    rebuild 1
    sha256 sonoma: "a581fed9ba7f1fa1aaa67993ca801a35c77fdd0aa278a78a187fa8c2872d6a04"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@3" # Intelbrew: CVD signature check fails on openssl@4/Intel (state/formula_edits.json)
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "share/clamav"

  def install
    args = %W[
      -DAPP_CONFIG_DIRECTORY=#{pkgetc}
      -DDATABASE_DIRECTORY=#{var}/lib/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"lib/clamav").mkpath
  end

  service do
    run [opt_sbin/"clamd", "--foreground"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{pkgetc}/
    EOS
  end

  test do
    assert_match "Database directory: #{var}/lib/clamav", shell_output("#{bin}/clamconf")

    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
