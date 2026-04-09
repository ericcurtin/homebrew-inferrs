class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409110816"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409110816/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "607097176d614382fe803b4b080d112b465274d59df819dbf25b4054d8a2d3cd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409110816/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9d726e69129da4024afda1817376fc862227acf1602d0d033a69ae04d3c3dc1"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409110816/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7a32c67cc0d7466bdb270ee6c5302d3ab85df94139913f03bb561ba8d44cb0ba"
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
