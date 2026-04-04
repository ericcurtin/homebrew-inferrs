class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260404195729"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195729/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "4e88bc8762ba37c76b23b7a96681196870695cf5575e5e1abffa24fe11e36d27"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195729/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e4ad9d0694df3d95fd37a8027f0c00de773b6e7d3e36b118513c32e110ef459f"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260404195729/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2744a84e4a713debe9d61f09f2fd22eefa78043180cb54274c027b238b84c53"
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
