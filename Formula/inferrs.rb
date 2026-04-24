class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260424164259"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424164259/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "05b8320faa70d944018f56575a95be61f7bab7483ed6e8a249cdfc051d151c64"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424164259/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bd115cd8f19704cc7c70dadba47ac40d2bf74472b71081558d7b1d89cca11f2a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260424164259/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b8c07a2c37282ae2cf5e907312e996fd212e7945d039923e0b818daa1236ddf5"
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
