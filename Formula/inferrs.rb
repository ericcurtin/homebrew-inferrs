class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "0.0.20260413141215"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413141215/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "f13bb25fe5e2508c069aee3d96c13d368ed83d9a374f76d5b380ac5c79849cac"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413141215/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c460dbce296efed7d2ecf1698221c39b049efaea4f646aae07a17b0e87c7215"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/0.0.20260413141215/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f143c01ce62b938c9df9301e81935d9659e68cfdc8b928757fbf79dce79013d3"
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
