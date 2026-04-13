class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413054425"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054425/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "0eae08f6413aae58955efe381e0cb5eefba44298520c125b476f83283640dd2a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054425/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ebbe63a92bbbf9508b09c68578c19ab928c8aec7c16cf64f3350b80620a9d040"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413054425/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "574d1e5a5a6d27ce1e6b26826ffb11cf188b44fedf7663e7295b02a7b406db6e"
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
