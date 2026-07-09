class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260709171024"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260709171024/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "9d9a94e1924869afb805a80a55891a49f2858b3f2755e5d60bc778f6ab448fab"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260709171024/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "be02cf7baa6da72cdfbaa864471ee5fae22c1f945b575f66c8109707c43ae038"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260709171024/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "75119ab543f3e29119a8cdc81cdf281602f4cce64996fab3fc8821d1a1f11c86"
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
