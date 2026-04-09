class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409092405"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409092405/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e0dd793505ac4e973f22321166f863a416736e4856abaa9cb95d263e5f6ce3ce"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409092405/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "619324504d589654048c255615f098bd2eb2efdbe76b7b8ce70e7210044ed0ac"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409092405/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "151213378229fe0ecd7d7c4d1bf868dfef59acb612314f5f3272b4480be41b0e"
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
