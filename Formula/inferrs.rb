class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409083247"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409083247/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e64b5d53574d58fce736aec932621cdc69c6bd6a58974e80b0158ced8d34d963"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409083247/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "698b4013cec2ef68786c770bdf2a99dafe21ae290b64e4341640fba503607208"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409083247/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "00f1677547edc7baaa49b4a44a55b5afc813212aae0721a9102a1a7d36f8ef5f"
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
