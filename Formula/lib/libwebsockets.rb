class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://github.com/warmcat/libwebsockets"
  url "https://github.com/warmcat/libwebsockets/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "9acbba00aaa9e6178ae09c6f920d95449b527c1417e81d2cdd4103bc6d64d13f"
  license "MIT"
  compatibility_version 7
  head "https://github.com/warmcat/libwebsockets.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/libwebsockets-5.1.0"
    sha256 sonoma: "a03a695a858c98abd606674dcac9d63bcb0e5cfc3db58c97c1bb6e33fb112399"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@4"

  deny_network_access!

  def install
    # HTTP/3 forces the GnuTLS backend from 5.0.0 onwards, which ttyd cannot build against.
    system "cmake", "-S", ".", "-B", "build",
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_HTTP3=OFF",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{formula_opt_prefix("openssl@4")}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
