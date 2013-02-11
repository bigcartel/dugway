require 'active_support/all'

require 'bigcartel-builder/application'
require 'bigcartel-builder/liquid'
require 'bigcartel-builder/store'
require 'bigcartel-builder/template'

module BigCartel
  module Builder
    def self.application(options={})
      Application.new(options)
    end
  end
end
