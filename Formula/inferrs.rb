class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260422151757"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260422151757/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e29980dcfa267562fc23d20d071e61f7addb656dd79cc25d37ed341dfe2dc3d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260422151757/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3a9fa52ac6b91c2d44dd8488654da459e2b383f4d8ed72c851d0b9f343a1bfca"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260422151757/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5fa8fe99771fac976fa366b3fdb1708e9d80eb7d588e1b046d159a3bf94e5517"
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
