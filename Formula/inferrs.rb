class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260417112012"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260417112012/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "e3f234af85584e771f29d88e595df2f293127be3f58d9ef85ea4ff74ab86c709"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260417112012/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dab45d02c0e67d1ee919457fffbda234f9b1c8856038487885df00a04359acb1"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260417112012/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e1da6268bd61fc9f4acbc7befbdfcc9d0e1b1ea08d51712e1e804c6fb0d43689"
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
