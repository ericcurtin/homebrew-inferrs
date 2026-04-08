class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260408122904"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122904/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "243cfc18921a089991a3dff2277d709317597e99a8078c9452241678eedc8e39"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122904/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8147fb3f2aa3013e64a5597a0e59a50b65dd42812a9603b383f2fb9778a69b96"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260408122904/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c2fd757139bf8e3bdba2296c439151ab04bcd832df42feb5287b349b3976efb8"
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
