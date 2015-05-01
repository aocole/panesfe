class Foldershow < Presentation
  validates :folder_zip, presence: true

  mount_uploader :folder_zip, ZipUploader

end
