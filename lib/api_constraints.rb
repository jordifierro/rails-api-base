class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default ||
      (req.respond_to?('headers') &&
       req.headers.key?('Accept') &&
       req.headers['Accept'].eql?(
         "application/vnd.railsapibase.v#{@version}"))
  end
end
