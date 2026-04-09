class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409021332"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409021332/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "60e4411145a5ee7bac101c51aaff3e138f511e6e2b9c1b08c412dc96dee808d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409021332/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7734098123e72463f9fe7e79802b7d38c61993b7aa71a6216a0ba68d29543add"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409021332/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36e934f6e5092665a371f7c41db230c0afbddace0280160dd4e0d9ad73af1af6"
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
