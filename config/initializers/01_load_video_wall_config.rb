class GrowingPanes
  def self.config
    return @config if @config
    config_file = ENV['VIDEO_WALL_CONFIG_FILE'] || Rails.root.join('config', 'video_wall_config.ini')
    @config = IniFile.load(config_file)

    # Special handling for certain fields
    @config['user']['upload_root_dir'] = File.expand_path(@config['user']['upload_root_dir'], Rails.root)

    return @config
  end

  def self.reload_config
    @config = nil
    config
  end
end

GrowingPanes.config # initializes config
