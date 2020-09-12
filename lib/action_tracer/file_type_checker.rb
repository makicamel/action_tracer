module FileTypeChecker
  def self.libraly?(path)
    gem?(path) || ruby?(path)
  end

  def self.gem?(path)
    path.include? "/usr/local/bundle/gems"
  end

  def self.ruby?(path)
    path.include? "/usr/local/lib/ruby"
  end
end