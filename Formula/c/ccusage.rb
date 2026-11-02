class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.47.tar.gz"
  sha256 "9e60d19e178c7e9d945bec0bae735a461315c5602e225d55b02fc23289a3f627"
  license "MIT"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ccusage-20.0.47"
    sha256 cellar: :any_skip_relocation, sonoma: "9eb2b9164d3857d93a1f4be943e6baa24c2dd2d4046f1d2d7960a34e34531602"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/60fc121ce8ab995cb2997e0bbd0a980ee93c627d/model_prices_and_context_window.json"
    version "60fc121ce8ab995cb2997e0bbd0a980ee93c627d"
    sha256 "7f7f1567bee2b7ba4118e4b9b3c1de70b122fd9164f69d9adfc12aca1033101a"

    # Fetch the latest available resource
    livecheck do
      url "https://api.github.com/repos/BerriAI/litellm/branches/main"
      strategy :json do |json|
        json.dig("commit", "sha")
      end
    end
  end

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    resource("litellm-pricing-json").stage buildpath
    ENV["CCUSAGE_PRICING_JSON_PATH"] = buildpath/"model_prices_and_context_window.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
