class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.5.tar.gz"
  sha256 "3d920afb666d51ebec3c80ec2847ae7ad14cca3badaaf39f1c0a175d100a4506"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ruff-0.17.5"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "816964034d84f39f7e55f750e976cf8861f5622a53f78a6a40cfc837c263f267"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
