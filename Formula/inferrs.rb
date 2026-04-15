class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260415140748"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260415140748/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "bafc1c770e2ae6f6930b9dde355a6e84bc01e49475da70ac1e48ce7246d2257b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260415140748/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6ffe1f5a3120e46e04c0e3759387e2a266809d09539e335aab3d09bb43ba1bc"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260415140748/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1360528d954b8fc3c0cfec407afc962af8fcd0e29309104400f234ac2c329235"
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
