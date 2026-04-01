class Inferrs < Formula
  desc "A conservative-memory inference engine for LLMs"
  homepage "https://github.com/ericcurtin/inferrs"
  version "5e8db78337fffc8338669ace1837c31477e39992"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-apple-darwin.tar.gz"
      sha256 "5ed99d10af79423755469cd7572c13b7ea4e9a8ac4f804a7f5c79fbbbb932597"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc7a6d9a2db5d0b246ce75492b1dc159f2fd49d79a59d7267f5014eeddd61439"
    elsif Hardware::CPU.arm?
      url "https://github.com/ericcurtin/inferrs/releases/download/latest/inferrs-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "118451e1fb747ed885c286d658825f8b46f7b845a64115c1e31f34476a4c3e50"
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
