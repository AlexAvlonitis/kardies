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
    return unless object.errors.any?
    return if object.errors.messages[field_name].blank?
    object.errors.messages[field_name].join(', ')
  end

  def title(text)
    content_for :title, text
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text = DEFAULT_DESCRIPTION)
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def show_flash_message
    flash_messages = []

    flash.each do |type, message|
      return unless message

      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe
    end

    flash_messages.join('/n').html_safe
  end

  DEFAULT_DESCRIPTION = 'Γνωριμίες Ελλάδα, το νέο απολύτως δωρεάν 100% ' \
                        'Ελληνικό site γνωριμιών. Γίνε κι εσύ μέλος σήμερα ' \
                        'για να γνωρίσεις τον επόμενο έρωτά σου. Γιατί όλοι ' \
                        'έχουν δικαίωμα στην αγάπη!'.freeze
end
