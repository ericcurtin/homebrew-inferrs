class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413203839"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413203839/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "4a174800707bcccf5969ed985e562ae9b2001364910fe6ac5fd710fb23b346ae"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413203839/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c5ed506b31bcb763c933e2b9beb10d1fba7ec6dc8dcb74dfce506fbf1a32c7a"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413203839/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6fc7b435c598948d954ebf3e664c9d159b34579b32e9cf8d4dd6e4334aac9c75"
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
