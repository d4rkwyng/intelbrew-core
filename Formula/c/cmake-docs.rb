class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.5.1/cmake-4.5.1.tar.gz"
  sha256 "a79bf33cbe05686fdf79c2bbbcfe5e8e62ad16d3d540fa737cbedfeed41fb69e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/cmake-docs-4.5.1"
    sha256 cellar: :any_skip_relocation, sonoma: "6bb6c4183d176048b152db0a097fde614d2ab61b2a61feec034b1b393ab37198"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  deny_network_access!

  def install
    args = %w[
      -DCMAKE_DOC_DIR=share/doc/cmake
      -DCMAKE_MAN_DIR=share/man
      -DSPHINX_MAN=ON
      -DSPHINX_HTML=ON
    ]
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
