class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260414132532"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414132532/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d0d72c00cb03f95fec68c785a2d8a2b102468ffcf3868ef5ea7334d297d12ab2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414132532/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0df89960546bc8ccb6baad42f13e713be9c6c6fe9b49c04c568669507c574b2d"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414132532/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7640fc0443d2c541f31d794d2d7fd30163e629dc2323f4d5dd231dcf79e0d2d5"
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
