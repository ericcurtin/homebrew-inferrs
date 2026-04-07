class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260407184022"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407184022/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "df98f43cb368e91b8d48e1b1acc3bbd613bb430698b0786ca1d8f8f375b57d7f"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407184022/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c1853e2545ffef4fe68afaa11519e8d4152bc211fce837b451025203d632755e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260407184022/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e2c9c06847ddc7a231a0dfb3dcafa55c65ca693cdac943befb91cf03f87e80c8"
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
