class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413220321"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413220321/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "fb868223f6c3dfe3828d65b53aebb80a5a2f053de39601b384ec4e1e523aafd9"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413220321/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1bb2b2427765f4932ac6fdf75003d3eb5455beed44d765e7f04795d0d3155c3c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413220321/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8258eed6eb2f74826aed3c6d70c432403a76546eab19b4269f4bad1b320fd090"
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
