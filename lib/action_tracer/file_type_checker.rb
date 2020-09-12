module ActionTracer
  class FileTypeChecker
    def initialize
      @pwd_path = Pathname.pwd.to_s
    end

    def app?(path)
      path.include? @pwd_path
    end
  end
end