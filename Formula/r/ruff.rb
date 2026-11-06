class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.4.tar.gz"
  sha256 "a466d837b406c888f4f76e4be808658f36846288aa87f81ac89afcf078ad386a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ruff-0.17.4"
    sha256 cellar: :any_skip_relocation, sonoma: "796261d1f04b2575baca527a6ff6f7d569cc39eea759dc1ad2886abd94c9bacd"
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
