class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "https://github.com/PJK/libcbor"
  url "https://github.com/PJK/libcbor/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "c94145d3c22e67cff9a3325dc036b4545a49a42231553995be4947d52cf2ef57"
  license "MIT"
  compatibility_version 3

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/libcbor-0.15.0"
    sha256 cellar: :any, sonoma: "d933782f6e641103a13c0237715efc8c284a249a635fd4711a9ab21578b15edf"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DWITH_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"example.c").write <<~C
      #include "cbor.h"
      #include <stdio.h>

      int main() {
        printf("Hello from libcbor %s\\n", CBOR_VERSION);
        printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
        printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
      }
    C

    system ENV.cc, "-std=c99", "example.c", "-o", "test", "-L#{lib}", "-lcbor"
    system "./test"
  end
end
