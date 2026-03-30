class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "553198cf206a3ae5ce33b76a80df8fefe11a91dd"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3a64a371dffb7a4014e03a45207700dee61a6779f5082a32127623744804a59f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "182728750ecd9508d614fe85a1ee17b3cfc24e1b49b9401a8dcded9c3cdbb97b"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e6339c441cd92c1c1da8adec7af5eec841f16cb15d371b36d2ab62fce240f13"
    end
  end

  def install
    bin.install "inferrs"
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
