module PresentationsHelper
  def edit_presentation_path(presentation)
    case presentation
    when Slideshow then edit_slideshow_path(presentation)
    when Foldershow then edit_foldershow_path(presentation)
    else
      raise "Don't know how to make an edit path for #{presentation.inspect}"
    end
  end
end
