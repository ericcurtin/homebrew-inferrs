class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260414141416"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414141416/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "048df161072762af025f257ef9bfd9dca686959d8de90106a7c126d0ffe5cae0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414141416/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6bb3701d783f3065ccc26e3f4118e0cdde15b35ffe4b1c7d0322bf22a56fbffe"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414141416/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "766baf4314de5ac62df56ac7d19e8913f68545dbfd6d4383e9e9e0cf6e784654"
    end
  end

   def install
     bin.install "inferrs"

     # Install GPU/NPU backend plugins alongside the binary so the
     # inferrs binary can find them via dlopen at runtime.
     %w[
       libinferrs_backend_cann.so
       libinferrs_backend_cuda.so
       libinferrs_backend_hexagon.so
       libinferrs_backend_musa.so
       libinferrs_backend_openvino.so
       libinferrs_backend_openvino.dylib
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
