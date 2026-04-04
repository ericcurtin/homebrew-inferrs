class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404195353"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195353/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "b559e81b4794a78cc1631dd0b59aae65e304a246143fdd3f82a239eb1790dc8d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195353/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eda1b52688547f569af4ebf5fe797d05c956d731db6a465947d7bf477a6f0ad2"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195353/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7df297e2e14d8f4aff49d996b0d913444186f5cb01782cfd822c363e952e81f2"
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
