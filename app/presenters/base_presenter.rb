class BasePresenter < SimpleDelegator
  def initialize(object, view)
    @object = object
    @view = view
    super @object
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @view
  end
end
