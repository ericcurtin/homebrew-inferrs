class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409124335"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409124335/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "857aa9a1c14f4966e5ba2d212c2b0376cbc1da5842edb8ca28ef43f8f896f114"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409124335/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6b3c477d6171e7d229431b309570391fc4dda37acc46c22d67ec4bedda37da85"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409124335/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0c85ba8b49d0479539e7898f3bd3308ab407bae9f3704f07f2984aa1653fa25b"
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
