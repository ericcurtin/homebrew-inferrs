class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404195752"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195752/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "00752cffd0c555d88e500e01e83e279b02e6256df9951c6140a94371432d15c9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195752/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45bc16dd6d1a84988e317fcfd1fa6ae196c1c3b1d7be7549492bf549ac189bac"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195752/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3d901c5b54f9e945b486fb10b6a37785ab53140b5b52ccd527b7805fb7bd546"
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
