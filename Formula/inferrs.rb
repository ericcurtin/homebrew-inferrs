class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411131338"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411131338/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "b78ac20cd66927630ee37d289b61c7ece863bfb4040dd0176f9f97f89887b4ab"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411131338/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "004e82763c88bd34fe713fb993730ea7c3f33a7251c01eabf127ecbef05dbf55"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411131338/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4c7b908dd00b5299db836b643c36eeb3c6d5ca048eea4a60df61463e5344ee3"
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
