class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260414175044"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414175044/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "3703d82b31ff7472405e87129cac7c37ac8be8090a76b90d4570d012320e76f1"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414175044/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7976cfe40d7ced407e7c7316186862901b2fc36c4ace2a9422be064ce2984bb7"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260414175044/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82bb44ed40a918ad1fe4bf6d648f1f804e48cf891dd0dbbe1a2823b0e79243be"
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
