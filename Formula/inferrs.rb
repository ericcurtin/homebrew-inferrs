class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260409112403"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409112403/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "bad02dea7b1e6723641f3b441443764b0e08cd0bb3760c093e3985641a08f8bd"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409112403/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4d4e194f696b2791a093d12ac3fb831cd5efc0aae97e83bb7045d096cfcae9bb"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260409112403/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0dddf3d95c58e131f45b870106cee9a84f5e5ed23fa743f386b1d912b67bea6"
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
