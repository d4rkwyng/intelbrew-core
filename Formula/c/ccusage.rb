class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.46.tar.gz"
  sha256 "06277577201ef6e90e82bcd209942cc2ba1bdcf67190c092460acd9564905eab"
  license "MIT"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/ccusage-20.0.46"
    sha256 cellar: :any_skip_relocation, sonoma: "b5b4d42bce3f93df35216b64674f5169eeb6cfa7d79a0e10a3c823fc802c820a"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/e7f481f9f481f778aafc630d08f51e2488d4399f/model_prices_and_context_window.json"
    version "e7f481f9f481f778aafc630d08f51e2488d4399f"
    sha256 "7a3608ef70147c8d097e019a554dc5d93a0cf53779bcf14abe4fa52de2e265c7"

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
