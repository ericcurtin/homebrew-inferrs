class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406190941"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406190941/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "5122c254e3e444075b18426874f7686c42ea387b9a4e889c30bc32b459b22cd1"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406190941/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6af3b87d2f63eb3124c52872f72e83114304762e7398259b306d3f98fc196367"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406190941/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a0a6ae46cb508769fe510320914f16fb50df2d459487faf2d9c8167007bea026"
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
