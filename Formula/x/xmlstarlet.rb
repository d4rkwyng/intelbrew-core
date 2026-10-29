class Xmlstarlet < Formula
  desc "XML command-line utilities"
  homepage "https://xmlstarlet.github.io/"
  url "https://github.com/xmlstarlet/xmlstarlet/releases/download/1.7.0/xmlstarlet-1.7.0.tar.gz"
  sha256 "df4c93458fc6b2ad144d65dccf3ef251349871e0578c5bc59edbfeecf9bf3454"
  license "MIT"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/xmlstarlet-1.7.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma: "c9642b94b75b8d03e6f84978805e384743fbe2549e4913b72c845b3033b9c8bd"
  end

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    bin.install_symlink "xml" => "xmlstarlet"
  end

  test do
    system bin/"xmlstarlet", "--version"
  end
end
