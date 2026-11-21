class AmplAsl < Formula
  desc "AMPL Solver Library"
  homepage "https://ampl.com/"
  url "https://github.com/ampl/asl/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "cf907bcd14ed172d75e3d0fd34f11b3f8e42154d696cf0f8c73e217f5bf149c6"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ampl-asl-1.0.2"
    rebuild 1
    sha256 cellar: :any, sonoma: "9f5b21ea6d3ca9c9a01dfa0688fe8fd834853b64719aef2f7af3a1fb6ef7baf3"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
    ]
    args << "-DUSE_LTO=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include "asl/asl.h"

      int main() {
          void* asl_instance = malloc(sizeof(void));
          free(asl_instance);
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/asl", "-L#{lib}", "-lasl"
    system "./test"
  end
end
