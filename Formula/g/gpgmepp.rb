class Gpgmepp < Formula
  desc "C++ bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.2.0.tar.xz"
  sha256 "6651c5f7f801543d5b676719df9fec8053b0a6f5aba40b98ca0d2bee11136f30"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgmepp/"
    regex(/href=.*?gpgmepp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/gpgmepp-2.2.0"
    rebuild 1
    sha256 cellar: :any, sonoma: "c9f93b86d0025362749436e6f4630d416c26aaa9b6bb02380540fa9112a6666d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "gpgme"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp_r (pkgshare/"tests").children, testpath

    flags = shell_output("pkgconf --cflags --libs gpgmepp").chomp.split
    system ENV.cxx, "-std=c++17", "run-genrandom.cpp", "-o", "test",
                    "-I#{include}/gpgme++", *flags
    system "./test", "--number", "10"
  end
end
