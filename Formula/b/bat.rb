class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "4474de87e084953eefc1120cf905a79f72bbbf85091e30cf37c9214eafcaa9c9"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/sharkdp/bat.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/bat-0.26.1"
    rebuild 1
    sha256 cellar: :any, sonoma: "95d874da79a690eaa30bed5f6589a758e969f6acb058d05247262a595e52a1d3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    # Generate assets outside Cargo's version-dependent build directories.
    ENV["BAT_ASSETS_GEN_DIR"] = buildpath

    system "cargo", "install", *std_cargo_args

    man1.install buildpath/"assets/manual/bat.1"
    generate_completions_from_executable(bin/"bat", "--completion")
  end

  test do
    require "utils/linkage"

    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output

    [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("oniguruma")/shared_library("libonig"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"bat", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
