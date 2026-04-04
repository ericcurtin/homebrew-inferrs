class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404204350"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404204350/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "00b4cc1e13a71876cf22edb794d94b72871f9bce8c64b7970e72975e2b5dae45"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404204350/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b8902ed27951cf4734e875c01b12b82ed9cb592d8203c8670122188e3323b8f4"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404204350/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f12854521590fdbd10dbe57db9cbe4f6b705a2c2b8320d0bf67a30ae6b002187"
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
