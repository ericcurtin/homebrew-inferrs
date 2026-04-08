class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408132234"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408132234/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "473a2870186e9b515076cc724aea287a64b2b9ba28d8032ef86d11f4722df545"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408132234/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6580c06327bdec08ec7675ff2167abb4a9c3db39b2b11536b6bfc7dba0d413b2"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408132234/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24ce9103a523f042f26789483fe2dba60d066cc33b2010c0fb8f80254201a81a"
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
