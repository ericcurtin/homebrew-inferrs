class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260411142710"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411142710/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "1fb2d2a6ddf4a0c36258dc7d42b23165b323ad9cba57afddc873512822d57c3c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411142710/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "09ba20fd0a1b270b076c0be430f98fde786624b1101a9e36a5535f05e69e7a6b"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260411142710/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d14e88f029593e89bd1cd7560e8af4ce3ed57bfbaf7b49ff4027325872536ea"
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
