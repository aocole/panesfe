module PresentationsHelper
  def edit_presentation_path(presentation)
    case presentation
    when Slideshow then edit_slideshow_path(presentation)
    when Foldershow then edit_foldershow_path(presentation)
    else
      raise "Don't know how to make an edit path for #{presentation.inspect}"
    end
  end

  def full_broken_messages presentation
    presentation.broken_message_keys.collect do |key|
      I18n.t Presentation.broken_message_to_i18n_key(key)
    end.join(' ').html_safe
  end
end
