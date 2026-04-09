class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409101059"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409101059/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "00525dd146dc76d6d42cac4e8248a6d5dbc2c0e8560e01c04edb15a139316329"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409101059/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d13e3d94f6c6a9d5f56838a7a6e670f4573abb7775dc975cb763e6fe1ebfa80"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409101059/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06fb88ec538df3b42eb53235a6fb22ba5aa5a38705d226bc075b8603dfa99a15"
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
