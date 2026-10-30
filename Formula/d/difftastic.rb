class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://difftastic.wilfred.me.uk/"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.72.0.tar.gz"
  sha256 "ed8e2d59d44d62289b17c9d241e469bd72565fadf13c260676fc7a23bc28a844"
  license "MIT"
  compatibility_version 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/difftastic-0.72.0"
    sha256 cellar: :any_skip_relocation, sonoma: "1ece9a3ffe39d394ab9fd005fa308297578289c6e7b803ccf84d16abddc87ee2"
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
