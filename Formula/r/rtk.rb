class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "35d20bf5da0480931879efe609e3fc66d6eb0c23252204a804d14e72d1baca49"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/rtk-1.0.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "17c49cec0d9eb0b8e2ea5558818d5e2abc6d7470f503fc5acf912d76e1ff0ad2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
