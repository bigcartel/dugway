require 'logger'

module Dugway
  class Logger < ::Logger
    def initialize
      Dir.mkdir(dir) unless File.exists?(dir)
      super(File.join(dir, 'dugway.log'))
    end

    def dir
      File.join(Dir.pwd, 'log')
    end

    alias write <<
  end
end
