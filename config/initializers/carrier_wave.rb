CarrierWave.configure do |config|
  config.root = Proc.new{GrowingPanes.config['upload_root_dir']}
end 
