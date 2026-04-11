class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411172958"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411172958/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "1b6854ae606a04b5dba67ea4f89b18c98c1703825cd40809e0d6de770b4f63f8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411172958/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d86a9f90a1a4d9b7f8a19b66e7b25d5d63df045c37d5bb2dced76b81a174e9ed"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411172958/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "22dfa59f3255e61655f4193df631cf32a41d87ca217b1cbee185639d88c5aed3"
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
