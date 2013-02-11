class BaseDrop < Liquid::Drop
  attr_reader :source
  # TODO: why is this throwing an error? undef :id # so we can use 'id' in drops
  
  def initialize(source = nil)
    @source = source
  end
  
  def context=(current_context)
    @params = current_context.registers[:params]
    @full_url = current_context.registers[:full_url]
    @path = current_context.registers[:path]
    @currency = current_context.registers[:currency]
    @settings = current_context.registers[:settings]
    super
  end
  
  def permalink_lookup
    nil
  end
  
  def before_method(method)
    if @source.has_key?(method)
      return @source[method]
    elsif permalink_lookup
      for item in permalink_lookup
        return item if item[:permalink] == method.to_s
      end
    end
    
    log "---- MISSING DROP METHOD: #{ self.class }.#{ method }  ----"
    log @source
    nil
  end
  
  def log(msg)
    # TODO: log somewhere
  end
end
