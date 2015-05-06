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
      Tempfile.create(['video_thumbnailer_', '.png']) do |tempfile|
        file = ::FFMPEG::Movie.new(current_path)
        # file.transcode(current_path, "-ss 00:00:05 -an -r 1 -vframes 1 -s #{width}x#{height}")
        file.screenshot(tempfile.path, { seek_time: 5, resolution: "#{width}x#{height}" }, preserve_aspect_ratio: :width)
        FileUtils.copy(tempfile.path, current_path)
      end
    end

  end
end
