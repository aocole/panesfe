  json.extract! slide.image, :size, :url
  json.extract! slide, :name, :id
  json.deleteUrl slide_url(slide)
  json.deleteType "DELETE"
  json.thumbnailUrl slide.image.thumb.url
