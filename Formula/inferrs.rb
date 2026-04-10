class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260410190018"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410190018/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "9c52493c6b3e801b671d6671ad210a57629608bc49034df794781f58472485f2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410190018/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dfbf84eef924e7a97c74d8c127eabce71e20622f40e14ece5ff4b6cd72db3304"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260410190018/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3313a54ab052ce8c1072bff34279c6d358733ada010bb0e805a2e5a8ccd3766f"
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
