class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    default || headers_include_version(req)
  end

  private

  attr_reader :version, :default

  def headers_include_version(req)
    req.headers['Accept'].include?("version=#{version}")
  end
end
