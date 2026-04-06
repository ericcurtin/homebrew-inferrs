class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406132412"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406132412/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d4e987f40f6c3045503dd71d5363588be3c61a90ecf2e01750c265d38de6966f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406132412/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eb5972967373463246e9898d0e07a79edf41ece96c50ae8965ff63fabb6f67de"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406132412/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "02388b18f2df7157c34fdfd8e186b9c803489db8f14293ada29a79ea66bd065d"
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
