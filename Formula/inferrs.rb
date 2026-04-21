class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260421211912"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421211912/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "5b70d2b723eeba2a060f883aecb2c254a6a785b3e250dc26a52bd66f088bc2b7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421211912/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b01f5d1f6b597ce8d9bef6d24ce39c2124118e7ddf6abc72ce8b0262be8654e0"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260421211912/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55787bf7d754d43ae406f171f6c84a3168d068bcd9b202f6deff51713ec23a62"
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
