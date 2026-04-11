class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411154152"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411154152/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "d5a5cf1e3bac9f74e05cee77594642e65b89146c3ecdf0451fe6829af2445933"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411154152/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b71a3d45b540c64568c93a75fd56083dd7efcc850d3a4a0130d62b6f2bdd82ec"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411154152/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e0d6628b3d8b1fa1ed9fcf2335654b4158051a3c4a6d0a222992b3c17320378"
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
