class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "git://git.ffmpeg.org/rtmpdump.git",
      tag:      "v2.6",
      revision: "138fdb258d9fc26f1843fd1b891180416c9dc575"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  compatibility_version 1
  head "git://git.ffmpeg.org/rtmpdump.git", branch: "master"

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/rtmpdump-2.6_2"
    rebuild 1
    sha256 cellar: :any, sonoma: "be96f419d8cc408d3f4909efc50ab31bade2bf751b19124af61bde2c5a2697c7"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  def install
    ENV.deparallelize

    os = if OS.mac?
      "darwin"
    else
      "posix"
    end

    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{os}",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system bin/"rtmpdump", "-h"
  end
end
