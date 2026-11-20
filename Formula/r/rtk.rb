class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "c5068215a2f3d8df7e1f6c98cac1863b6fa69bd84f282669516fdba383440ed6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/rtk-1.2.1"
    sha256 cellar: :any_skip_relocation, sonoma: "77b7ff9270b9b3ab0350742f8362d5fae4e654f672dde410f9f2600c97bf7fd5"
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
