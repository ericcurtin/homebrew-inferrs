class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404163230"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404163230/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e96ecf2820e569a0019c76782e30aeda5dc3798df314ff8d5967426d2332825b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404163230/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df7bdd2f4d5283f347f1485e1f17d9ea33bbe5ece8f3fa2350dde6a1e1ded911"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404163230/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8676ff5a06f85c3490ff69451c8514b8394daf45de7ad0a10ecd4d44403858cd"
    end
  end

  def install
    bin.install "inferrs"

    # Install GPU backend plugins alongside the binary so the
    # inferrs binary can find them via dlopen at runtime.
    %w[
      libinferrs_backend_cuda.so
      libinferrs_backend_rocm.so
      libinferrs_backend_vulkan.so
    ].each do |plugin|
      bin.install plugin if File.exist?(plugin)
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
