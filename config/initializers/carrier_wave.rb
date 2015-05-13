CarrierWave.configure do |config|
  config.root = Proc.new{GrowingPanes.config['user']['upload_root_dir']}
end 
