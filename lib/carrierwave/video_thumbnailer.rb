module CarrierWave
  module VideoThumbnailer
    extend ActiveSupport::Concern

    module ClassMethods
      def video_thumb(width, height)
        process :video_thumb => [width, height]
      end
    end

    def video_thumb(width, height)
      FFMPEG.logger = Rails.logger
      FFMPEG.ffmpeg_binary = 'avconv'
      Tempfile.create("video_thumbnailer_") do |f|
        FileUtils.move(current_path, f.path)
        file = ::FFMPEG::Movie.new(f.path)
        # file.transcode(current_path, "-ss 00:00:05 -an -r 1 -vframes 1 -s #{width}x#{height}")
        file.screenshot(current_path, { seek_time: 5, resolution: "#{width}x#{height}" }, preserve_aspect_ratio: :width)
      end
    end

  end
end
