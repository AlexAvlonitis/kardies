class BaseService
  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementError
  end
end
