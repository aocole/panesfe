class GrowingPanes
  def self.config
    return @config if @config
    @config = IniFile.load(Rails.root.join('config', 'video_wall_config.ini'))

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
