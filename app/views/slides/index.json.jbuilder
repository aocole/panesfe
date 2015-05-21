# This is only used as a response to jquery.fileupload reqs
json.files @slideshow.slides.rank(:row_order) do |slide|
	json.partial! 'slide', slide: slide
end
