class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.5.tar.gz"
  sha256 "6997744f02e79e8e913cc4adb3bf790d5a4c3dce1bcf186234ee9f3cddf09645"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/swiftformat-0.64.5"
    sha256 cellar: :any_skip_relocation, sonoma: "57afb7dfbf60ddebb4c339fd13be8c950d61b2f2cffb79e5a70c8b1bc20daf25"
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
