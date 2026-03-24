class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "1b7b507b26d1538eded66eb1925ea6898ae57ca0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "25325b0bfb6c13a0c6c5129ee4a12d70d07bc12e0d4f3427dbac4816b3dbdc04"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "768c0551c0e9d771ee329f7b74981fad73a238b834ddf6c337a9e056cea1c782"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b42c9f7de3a8da0ff2a18675a60b5a8105cc36fe15621fb52f0c540cc1fd65f3"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
