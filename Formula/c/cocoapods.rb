class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.17.0.tar.gz"
  sha256 "1a3e63e815e61ad7661326d6e6ba2593328a596ceb94953d4388e3fe01e27f90"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/cocoapods-1.17.0_1"
    sha256 cellar: :any_skip_relocation, sonoma: "b75c4b19b04fe10a8c795a4ea62a56c07cc68c2f66f9080b460762409f6686b7"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"
  uses_from_macos "libffi"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system bin/"pod", "list"
  end
end
