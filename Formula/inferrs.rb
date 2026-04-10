class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260410223755"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410223755/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "fc97dcc9c524b4628abc7473ecae622e06b2d823e753fb1de9de7bb2301bd702"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410223755/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7be7dfb78c79d036f803170730b6845bdb2b5a9bfdd855f0e32c071921bc8ec6"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410223755/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "83c962408d25820454ec28e568bb27cf72748f01dd4528305c72b8797049cc9a"
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
