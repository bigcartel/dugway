require 'active_support/all'

require 'bigcartel-builder/application'
require 'bigcartel-builder/liquid'
require 'bigcartel-builder/store'
require 'bigcartel-builder/template'

module BigCartel
  module Builder
    def self.application
      Application.new
    end
  end
end
