class GrowingPanes
  def self.config
    return @config if @config
    @config = IniFile.load(File.join(Rails.root, 'config', 'video_wall_config.ini'))

    # Special handling for certain fields
    @config['user']['upload_root_dir'] = File.expand_path(@config['user']['upload_root_dir'], Rails.root)
  end
end

GrowingPanes.config # initializes config
