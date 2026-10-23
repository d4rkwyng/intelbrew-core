class Qtquickeffectmaker < Formula
  desc "Tool to create custom Qt Quick shader effects"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtquickeffectmaker-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtquickeffectmaker-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtquickeffectmaker-everywhere-src-6.12.0.tar.xz"
  sha256 "290c8c3c9835e9d3991cbf7e8fe965992c8f7c8730e694f7cf90fb719c2c63ac"
  license all_of: [
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
    "BSD-3-Clause", # BlurHelper.qml
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquickeffectmaker.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/qtquickeffectmaker-6.12.0"
    rebuild 1
    sha256 cellar: :any, sonoma: "08d00b59a4720b3ebc23002303a6fb4e32350547b594fb808aebc6541bb50d42"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"
  depends_on "qtshadertools"

  def install
    # FIXME: app bundle is broken as CFBundleExecutable doesn't match after rename
    inreplace "tools/qqem/CMakeLists.txt", 'set(EXECUTABLE "qqem")', 'set(EXECUTABLE "Qt Quick Effect Maker")'

    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework")

    bin.glob("*.app") do |app|
      libexec.install app
      (bin/"qqem").write_env_script libexec/app.basename/"Contents/MacOS"/app.stem, {}
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal"
    assert_match "Qt Quick Effect Maker", shell_output("#{bin}/qqem --help")
  end
end
