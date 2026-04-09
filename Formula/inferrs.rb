class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409054846"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054846/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "c31ad4b54d059091a52ed70b889b9d1c766faeb3fdf46249f8c0d311e23cc8fe"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054846/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3c5e1487ff4fe8f9e3dd55ad85371ba14631e1b6ec22b5416c5428bad08ea06"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409054846/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60740828dd9651841590f9e27d3ca45e01dd25fe314db8a87096930270df4219"
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
