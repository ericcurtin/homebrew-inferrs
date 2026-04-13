class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413201221"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201221/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "efbc36bdede2f7df580744e213bcbe5173695792cdf3cb65ff688c20d3d4fb78"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201221/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f19550f2dbc22ccb9634e6c4adae72f90c00dce5fb384ee7115608dee6b1a599"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413201221/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1ee0f2eb25dd68c1808c5e2f32ebe2a561ec830c71e4066fcaccf841c31e0eef"
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
