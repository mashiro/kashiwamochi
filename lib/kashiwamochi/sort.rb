require 'active_support/core_ext'

module Kashiwamochi

  class Sort
    DIRS = {:asc => 'ASC', :desc => 'DESC'}.freeze

    def initialize(key, dir)
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

    def toggle
      @dir = asc? ? DIRS[:desc] : DIRS[:asc]
    end

    def asc?
      @dir == DIRS[:asc]
    end

    def desc?
      @dir == DIRS[:desc]
    end

    def valid?
      @key.present?
    end

    def to_query
      "#{key} #{dir}"
    end

    def inspect
      "#<Sort #{key}: #{dir}>"
    end

    def self.sanitize(value)
      value.to_s.strip
    end

    def self.sanitize_dir(dir)
      sanitize(dir).upcase != DIRS[:desc] ? DIRS[:asc] : DIRS[:desc]
    end

    def self.parse(value)
      key, dir = sanitize(value).split(/\s+/, 2)
      Sort.new(key, dir)
    end
  end

end
