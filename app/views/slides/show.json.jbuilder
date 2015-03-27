json.files [@slide] do |slide|
	json.partial! 'slide', slide: slide
end
