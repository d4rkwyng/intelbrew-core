class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "eec7ef8641d221e144a58d5ef8d733c8c75c7fd487097a233aacb4fa33981cfb"
  license "BSD-3-Clause"
  compatibility_version 3
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/hiredis-1.5.0"
    rebuild 1
    sha256 cellar: :any, sonoma: "848f1a197473c632de197e0a2e82b495267e6e2d0e558172a0cb3e3d2a1276d4"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}", "USE_SSL=1"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_path_exists testpath/"test"
  end
end
