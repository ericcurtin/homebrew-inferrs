class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260405161247"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405161247/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "23f2ce3a158e1159f791a83e6a354a4cff7f81816456ff9e091447d94e715001"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405161247/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7644630572daaffee5f98d23d9f3693886e7ca9f95d052a6836b7a9a5349b08e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260405161247/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7707aa7a9fce2262ed370b2c7728e4fa03944acdd1995f5d79ef64b4347339e0"
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
