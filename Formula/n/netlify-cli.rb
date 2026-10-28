class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-27.14.3.tgz"
  sha256 "376b46029d7eec325cef8cc5508f1aadcd00e98bd74994035ec50edf1bf09a53"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d7a150fcd73a4107db705eca0e48cb2f0fce3ce0412df93ec5ed7281f74894e"
    sha256 cellar: :any, arm64_tahoe:       "db6f8cf2e8ae64e1d99cb904b8c41a8dcef7616a3b4127a837defbe1b174af7c"
    sha256 cellar: :any, arm64_sequoia:     "95688aa54a9b7408143b86fcb3e3d16f21bb84598f684af67ba7c112c988810d"
    sha256 cellar: :any, arm64_linux:       "c935200ed78e0ccecc99ea5065a5226a8f265d512f254ee98611e2a1dc404ab8"
    sha256 cellar: :any, x86_64_linux:      "c7f51f25b772762a36f91883ffbdb984885bda191e08944d81a31181287161e1"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gmp"
    depends_on "xsel"
  end

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "npm", "install", *std_npm_args(ignore_scripts: false), *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible and unneeded pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"
    rm_r(node_modules.glob("@img/sharp-*"))
    rm_r(node_modules.glob("@parcel/watcher-{darwin,linux}*"))

    # sharp 0.35+ no longer builds from source on install, so build it against brewed `vips` explicitly
    cd node_modules/"sharp" do
      system "npm", "run", "build"
      rm_r("src/build/Release/obj.target")
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir, force: true) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see project status.", shell_output("#{bin}/netlify status")

    require "utils/linkage"
    sharp = libexec.glob("lib/node_modules/netlify-cli/node_modules/sharp/src/build/Release/sharp-*.node").first
    libvips = formula_opt_lib("vips")/shared_library("libvips")
    assert sharp && Utils.binary_linked_to_library?(sharp, libvips),
           "No linkage with #{libvips.basename}! Sharp is likely using a prebuilt version."
  end
end
