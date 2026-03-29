class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "919cc88d67f57866cdcf66ec4834afd28b5cb58f"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "6141410e40a047bd02f098b1dbbc75a3d134f5835218729c04f0405d745b11e2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b635798a1e86c63cbac7385499e40c9effbc74c5ef39e204b39683a143f451f"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bff9d79b5b4fe561c918b1c96efeaed5271552e3e5ee1304011ea2ebda169c3"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
