class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "623111bddb2d7f6f4ba2e64038f91f8b673bd6f95dd6fcbaf334b7af7789b48d"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/maturin-1.15.0_1"
    rebuild 1
    sha256 cellar: :any, sonoma: "ca6e59e14f796e8ccaea1649967c57ae56cce95d73c824437c4ce9acdc8a9cae"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.15" => :test
  depends_on "xz"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    system "cargo", "init", "homebrew", "--name=brew", "--bin"
    cd "homebrew" do
      system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
      system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
      system python3, "-c", "import maturin"
    end
  end
end
