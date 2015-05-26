class GrowingPanes
  def self.config
    return @config if @config
    config_file = ENV['VIDEO_WALL_CONFIG_FILE'] || '/etc/video_wall_config.json'
    @config = JSON.parse(File.read(config_file))

    # Special handling for certain fields
    @config['upload_root_dir'] = File.expand_path(@config['upload_root_dir'], Rails.root)

    return @config
  end

  def self.reload_config
    @config = nil
    config
  end
end

GrowingPanes.config # initializes config
