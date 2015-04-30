# This is only used as a response to jquery.fileupload reqs
json.files @slideshow.slides do |slide|
	json.partial! 'slide', slide: slide
end
