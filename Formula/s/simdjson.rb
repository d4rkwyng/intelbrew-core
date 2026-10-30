class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.7.tar.gz"
  sha256 "a5282c9b00f6c8b5217f434636c78ee7c9019f2fd2aa478ba850d2e2584c0994"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/simdjson-5.0.7"
    sha256 cellar: :any, sonoma: "64b597a513f6bb3b44f962c491616c1f815ea08653523fd2f5a477de424b0178"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
