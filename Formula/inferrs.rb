class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "824b866316179a1f03b709d6c8ec766fea0e6a95"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "2c1410f200b2257d2083f6637ebbb64c4e58fa6d92c277a96c91b1ccccb6b3c2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ff7ddd0eff437eebb21792d3234973016ec4be3bce5f8a0619479e9262c0c51e"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d2ff467a9e6685564672b5f246a1b446ca2a6ba2ad665f963b0e00415d9d5513"
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
    ].each do |lib|
      (lib_path / "inferrs" / lib).install lib if File.exist?(lib)
    end
  end

  def post_install
    # Create a symlink so the binary can find sibling plugins in the
    # same directory (the binary searches its own dir first).
    # On Linux, also link into the standard search path.
    return unless OS.linux?

    plugin_dir = lib_path / "inferrs"
    bin_dir    = bin.realpath
    plugin_dir.children.select { |f| f.extname == ".so" }.each do |so|
      (bin_dir / so.basename).make_symlink(so) unless (bin_dir / so.basename).exist?
    end
  end

  test do
    assert_match "inferrs", shell_output("#{bin}/inferrs --help")
  end
end
