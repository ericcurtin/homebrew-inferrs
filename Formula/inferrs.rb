class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413163036"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413163036/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "993731579005bbdacede1c8c87620cbbd85433022d5af724c6bacabfe29c7860"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413163036/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9477e088ac2fb53b0610ff4789804a3a847c25dc85f6aaf7149782e0272406c2"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413163036/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a7786cc0a0751259f4c8d2bee6b47338693054a7daaeaef18f18157dc63bd0b0"
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
