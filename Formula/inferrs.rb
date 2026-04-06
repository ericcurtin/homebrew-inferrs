class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260406124105"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406124105/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "6137852dfea67b1124fd64acd55cdf5cf4c2e38b2765cdfc52d6a887c78a016f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406124105/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e90c4dff6096a7dbf65cd38657f2214307b528f1d5fc709c00d74863883059e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260406124105/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4f88a518d41fdcd5108ab66ab37b8f127c865a7683f2fdd61737b7e52e328286"
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
