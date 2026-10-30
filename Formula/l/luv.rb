class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https://github.com/luvit/luv"
  url "https://github.com/luvit/luv/archive/refs/tags/1.53.0-1.tar.gz"
  sha256 "e7d7c872637560e9e9ac0cdcaad1b06c4058152fb0eb9d039f38612b183d01a7"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/luvit/luv.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/luv-1.53.0-1"
    sha256 cellar: :any, sonoma: "1ce4480a338c7d6419688ef31276730e15c70a69eadfb7421f91c30c0eb309ca"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https://github.com/lunarmodules/lua-compat-5.3/archive/refs/tags/v0.15.1.tar.gz"
    sha256 "16c4bd7b72a156e3b575ce2b5ebe2ec00611a14c485dd15dc3814647a589c7f8"
  end

  deny_network_access!

  def lua
    Formula["lua"]
  end

  def install
    resource("lua-compat-5.3").stage buildpath/"deps/lua-compat-5.3" if build.stable?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}/deps/lua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    # https://github.com/luvit/luv/issues/787#issuecomment-4041758224
                    "-DMODULE_INSTALL_LIB_DIR=#{lib}/lua/#{lua.version.major_minor}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("#{lua.bin}/lua test.lua")
  end
end
