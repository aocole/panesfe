# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Create a bootstrap admin user if we don't have one
admin = User.where(role: User.roles[:admin]).first || User.create!(
    email:'admin@example.com',
    password: 'changeme',
    provider: 'devise',
    uid: Devise.friendly_token,
    role: User.roles[:admin]
  )

if Theme.count < 1
  puts "Creating themes..."
  Theme.create!(
    content: File.read(Rails.root.join('seed', 'themes', 'slide.html')),
    user: admin,
    name: 'Slide',
    description: "Images slide from right to left"
  )

  Theme.create!(
    content: File.read(Rails.root.join('seed', 'themes', 'slide.html')).sub("animation: 'slide'", "animation: 'fade'"),
    user: admin,
    name: 'Fade',
    description: "Crossfade between images"
  )
end

theme = Theme.where(name: 'Fade').first || Theme.first

if Presentation.count < 1
  puts "Creating presentation..."
  slideshow = Slideshow.new(
    user: admin,
    name: 'Demo Presentation',
    theme: theme
  )
  slideshow.save!
  slide = slideshow.slides.build
  slide.image = File.open(Rails.root.join('seed', 'images', 'cast-of-growing-pains.jpg'))
  slideshow.save!
end
