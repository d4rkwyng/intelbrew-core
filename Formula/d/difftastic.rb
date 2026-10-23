class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://difftastic.wilfred.me.uk/"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.71.0.tar.gz"
  sha256 "d6afd26103c6492a91307dc6779c7dd0ca4d4c85499f81d7dc53fdfa5107331d"
  license "MIT"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/difftastic-0.71.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "bc309fbc692ebf709a25ccdfc3f3721d05f5cc94692e538a747f995abdac3547"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "difft.1"
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                  1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
