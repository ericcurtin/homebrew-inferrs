class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413054029"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054029/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "8c2f2c1ae37925637de95412255886c72a766f4667f2484cad56bc72694069f9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054029/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d139f5718a07f76ebd9c8ca9582873ab5c90e8eb937de398c8a1173a3811868"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054029/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a6f7ce1c4630c8c4d90b59cb27bc5398df4600ef0d8822a0911d21d26c7c37dc"
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
