class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.17.crate"
  sha256 "c96f02f0d76ce0637914bd1c54787624573e8e5d1301d337db66f5e6f12e6eb6"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/llmfit-1.1.17"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "0483b38fe873ed2eec2443ada77d28736d1c34319eeb6262194bf4cfb3993913"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end
