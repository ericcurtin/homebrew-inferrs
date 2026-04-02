class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "5f4de1954ac40c0f21aa4c3d1e9d9a1d991dcf25"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "ef7aec5b877cc7fbadb75f7732c85c34ef9a932496e33efa036a532f5de07a53"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ee11a1282977b9d9e0d4cc1cb537b5b6d79c5e4cc83a8fab8bbe8ff4a63e8e3"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e5125a9a67d0172635e1218269052ad1aaef2f55b746a6a995aba10d966503f8"
    end
  end

  def install
    bin.install "inferrs"

    # Install GPU backend plugins alongside the binary.
    # The inferrs binary probes these at runtime via dlopen — only the
    # plugins that match the host hardware are actually used.
    # Missing plugins are silently skipped (CPU fallback applies).
    %w[
      libinferrs_backend_cuda.so
      libinferrs_backend_rocm.so
      libinferrs_backend_vulkan.so
    ].each do |plugin|
      (lib / "inferrs" / plugin).install plugin if File.exist?(plugin)
    end
  end

  def post_install
    # Create a symlink so the binary can find sibling plugins in the
    # same directory (the binary searches its own dir first).
    # On Linux, also link into the standard search path.
    return unless OS.linux?

    plugin_dir = lib / "inferrs"
    bin_dir    = bin.realpath
    plugin_dir.children.select { |f| f.extname == ".so" }.each do |so|
      (bin_dir / so.basename).make_symlink(so) unless (bin_dir / so.basename).exist?
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
