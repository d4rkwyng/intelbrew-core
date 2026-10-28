class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.45.tar.gz"
  sha256 "ef6530be9b83b79b9908a0e4d1c18c8c8d1ff0c62ca88b2437d73f9c865b4b29"
  license "MIT"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ccusage-20.0.45"
    sha256 cellar: :any_skip_relocation, sonoma: "f5f838ce85984a738eacf4f55ccbaaefdaecbfee802074330bd845b0e9c9b25a"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/2e27a02a9fce9bdc6ece13ba3cb8222dc5b6ecfa/model_prices_and_context_window.json"
    version "2e27a02a9fce9bdc6ece13ba3cb8222dc5b6ecfa"
    sha256 "db69fee424413c7abfb45616f2db08b6a8cfdc934a264ec7ac17e333e1a9df02"

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
