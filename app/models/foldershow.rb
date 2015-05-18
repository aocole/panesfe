class Foldershow < Presentation
  validates :folder_zip, presence: true
  validate :folder_zip_might_work, if: Proc.new {|show| show.folder_zip && show.folder_zip.path}

  mount_uploader :folder_zip, ZipUploader

  def folder_zip_might_work
    errors.add(:folder_zip, :no_index_found) unless find_index
  end

  def find_index
    Zip::File.open(folder_zip.path) do |zipfile|
      zip_entry = zipfile.find_entry('index.html')
      zip_entry ||= zipfile.entries.detect{|e| e.name =~ /(\/|^)index.html$/ && !(e.name =~ /^__MACOSX/)}
      return zip_entry ? zip_entry.name : nil
    end
  end

end
