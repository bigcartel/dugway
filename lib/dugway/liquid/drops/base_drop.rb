class BaseDrop < Liquid::Drop
  attr_reader :source
  
  def initialize(source=nil)
    @source = source
  end
  
  def context=(current_context)
    @store = current_context.registers[:store]
    @params = current_context.registers[:params]
    @full_url = current_context.registers[:full_url]
    @path = current_context.registers[:path]
    @currency = current_context.registers[:currency]
    @settings = current_context.registers[:settings]
    super
  end
  
  def before_method(method)
    if @source.respond_to?('has_key?') && @source.has_key?(method)
      return @source[method]
    elsif @source.is_a?(Array) && @source.first.has_key?('permalink')
      for item in @source
        return item if item['permalink'] == method.to_s
      end
    end
    
    nil
  end
  
  def log(msg)
    # TODO: log somewhere
  end
end
