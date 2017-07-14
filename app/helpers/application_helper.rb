module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def admins_only
    yield if current_user.try(:admin?)
  end

  def show_errors(object, field_name)
    if object.errors.any?
      if object.errors.messages[field_name].present?
        object.errors.messages[field_name].join(', ')
      end
    end
  end
end
