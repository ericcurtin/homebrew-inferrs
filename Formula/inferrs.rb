class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260418103245"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103245/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "0fa021f225c5c13df86a00604a71ac7a023b3ba640d5ddde623020d03528a353"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103245/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "622e6ee99ad896e6ee21f982248d41620ac285a443dcd4043038a7dd3912e9f6"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103245/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "76fc9b4b422bcdce5ef4c01d8a40d315a50ff239a0558d79527342e3b3185b5c"
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
