class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260414212302"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414212302/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "c867c4c2e2ff5aeb6a8d361567a8f29b52667ec145c1c9e0ba34db00c75a4376"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414212302/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "97b7d397cd076d6dd4d51242a29d734ec3abab45dc3882071cf0b3c715aeee62"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414212302/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e322cf0ddcba9fdb66235cb2a3a555eb8a7bc2160ad7dc45ae76453184140c3f"
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
