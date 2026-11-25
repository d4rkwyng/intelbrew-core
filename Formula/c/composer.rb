class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.11.3/composer.phar"
  sha256 "04f8b003da4e3a2459056591fbfebd02b4dc3e5adeb158616b90cf55a65113ec"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    root_url "https://github.com/d4rkwyng/intelbrew-core/releases/download/composer-2.11.3"
    sha256 cellar: :any_skip_relocation, sonoma: "35ba134d99241b75863a99faf09817915bcebd73f2b341d1b97dd911092159c5"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
  end

  allow_network_access! :test

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
