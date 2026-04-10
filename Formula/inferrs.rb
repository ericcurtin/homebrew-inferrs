class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260410195154"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410195154/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "35edaaac0750887768b38d8ba66459dfa79c81aa786948d878a882c3f3b5ed54"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410195154/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "98f15d4b066481fcce9cace3783c169637115b72ce41a450fb633c97fcee6aa5"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410195154/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b20df3a0d23a4fc670643fb3c2dc8638e4a29477d3f544869feee24d78fd674"
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
