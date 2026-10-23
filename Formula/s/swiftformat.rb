class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.0.tar.gz"
  sha256 "064d59b03f9c5d10971198dda3d9b05e301c1ada8e3d4c1a5132babc6b31a563"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/swiftformat-0.64.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "aece4afb40946fecde135b94027ef4b8cfe4e5330272b41475a70f36046124fb"
  end

  uses_from_macos "swift" => :build

  deny_network_access!

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", testpath/"potato.swift"
  end
end
