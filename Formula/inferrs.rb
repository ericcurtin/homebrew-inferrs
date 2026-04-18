class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260418103230"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103230/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "cce0582f26ad1f033ffc41af8bde5e0ec46942e41570b0cc04e09483332527b7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103230/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "59d6974e13bba45f78ecd92329a81948ad7958f8ba2e55cec24df78bb7481c6c"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260418103230/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9075f4a2cb7c566103656b0667d6e8eb7683eb0c504570c3ee9fb63cbea295cf"
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
