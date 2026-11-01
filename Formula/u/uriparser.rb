class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.github.io/"
  url "https://github.com/uriparser/uriparser/releases/download/uriparser-1.0.3/uriparser-1.0.3.tar.bz2"
  sha256 "5daa0757f9866af8535398e7a49278faa6af1ff81695c9280c3a5a424bb328c6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/uriparser/uriparser.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/uriparser-1.0.3"
    sha256 cellar: :any, sonoma: "0b9f78d02fdb6170c9d89ed6fa965fdfe513c6121e323a5f870fa6582dc6357c"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DURIPARSER_BUILD_TESTS=OFF
      -DURIPARSER_BUILD_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
                    (always false for URIs with host)
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
