module FormErrorHelper
  def field_error(obj, attribute, options = {})
    options[:class] ||= 'help-block'

    content_tag(
      :span, obj.errors[attribute].try(:join, ', '),
      :class => options[:class]
    ) if obj.errors.include?(attribute)
  end

  def form_group_error_class(obj, attribute)
    obj.errors.include?(attribute) ? 'has-error' : ''
  end

end
