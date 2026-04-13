class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413180539"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413180539/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "240b025ca698d96ec94b8187a40192127a94e2bb0d1c689c0f0e3bd5dd130997"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413180539/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9eb39c484a1ccf357921ddaf45ba148228bdcad65cc52348f1019f91853c10b4"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413180539/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48372313c71c5b4c5ff601a27a8a654e48958633f4b53e201f92822758bc8395"
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
