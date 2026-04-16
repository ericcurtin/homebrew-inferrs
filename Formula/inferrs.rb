class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260416102256"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102256/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "c44c9911868969356283d33807f5fc77e894a8e281b924d1287e0cbbbd9e1c72"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102256/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0d8b1f2d2253b2df4e45aa57ed63a0febff2dd39fdb71550219bf3f43c9b431c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260416102256/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c7b82888b90ee987191b5e51688a6512f7691876338eaf93c5026ce2027f15c"
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
