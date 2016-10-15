module ApplicationHelper

  def present(object, klass= nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def foundation_class_for flash_type
    { success: "success", error: "alert", alert: "warning", notice: "info" }[flash_type.to_sym] || flash_type.to_s
  end

end
