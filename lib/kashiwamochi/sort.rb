module Kashiwamochi
  class Sort
    DIRS = {:asc => 'asc', :desc => 'desc'}.freeze

    def initialize(key, dir = nil)
      self.key = key
      self.dir = dir
    end

    def key
      @key
    end

    def key=(value)
      @key = Sort.sanitize(value)
    end

    def dir
      @dir
    end

    def dir=(value)
      @dir = Sort.sanitize_dir(value)
    end

    def toggle!
      @dir = asc? ? DIRS[:desc] : DIRS[:asc]
      self
    end

    def toggle
      self.dup.toggle!
    end

    def asc?
      @dir == DIRS[:asc]
    end

    def desc?
      @dir == DIRS[:desc]
    end

    def valid?
      !@key.empty?
    end

    def to_query(map = nil)
      "#{map || key} #{dir}"
    end

    def inspect
      "#<Sort #{key}: #{dir}>"
    end

    def self.sanitize(value)
      value = value.first if value.is_a?(Array)
      value.to_s.strip
    end

    def self.sanitize_dir(dir)
      sanitize(dir).downcase != DIRS[:desc] ? DIRS[:asc] : DIRS[:desc]
    end

    def self.parse(value)
      key, dir = sanitize(value).split(/\s+/, 2)
      new(key, dir)
    end
  end
end
