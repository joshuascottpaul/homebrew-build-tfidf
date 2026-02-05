class BuildTfidf < Formula
  include Language::Python::Virtualenv

  desc "High-quality semantic search for Markdown corpora"
  homepage "https://github.com/joshuascottpaul/build_tfidf"
  url "https://github.com/joshuascottpaul/build_tfidf/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "661edde9dc80ce82997fb52bf95d2490a28655e48a3f67a278533b87c6aa5592"
  license "MIT"

  depends_on "python@3.10"

  def install
    ENV["HOMEBREW_SKIP_RELOCATE"] = "1"
    venv = virtualenv_create(libexec, "python3.10")
    system libexec/"bin/python", "-m", "ensurepip"
    system libexec/"bin/python", "-m", "pip", "install", "--only-binary", ":all:", "--no-deps", "-r", buildpath/"requirements.txt"
    system libexec/"bin/python", "-m", "pip", "install", "--no-deps", "--no-build-isolation", buildpath
    bin.install_symlink libexec/"bin/tfidf-search"
  end

  def caveats
    <<~EOS
      This formula skips Homebrew relocation because the tiktoken wheel ships a
      non-relocatable native extension. Relocation would fail during install.

      Risk: binaries remain linked to their original install path. If you move
      the Cellar or use nonstandard prefixes, reinstall may be required.
    EOS
  end

  test do
    system bin/"tfidf-search", "--help"
    (testpath/"corpus").mkpath
    (testpath/"corpus/alpha.md").write "# Alpha\n\nalpha note"
    system bin/"tfidf-search", "build", "--root", testpath/"corpus"
  end
end
