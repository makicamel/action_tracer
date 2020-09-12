module ActionTracer
  class FilePathChecker
    def initialize(pwd_path)
      @pwd_path = pwd_path
    end

    def app?(path)
      path.include? @pwd_path
    end
  end
end