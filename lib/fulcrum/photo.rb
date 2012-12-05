module Fulcrum
  class Photo < Api

    ALLOWED_FORMATS = %w(jpg json)

    class << self

      def find(id, opts = {})
        format = image_opts(opts)
        call(:get, "photos/#{id}.#{format}")
      end

      def thumbnail(id, opts = {})
        format = image_opts(opts)
        call(:get, "photos/#{id}/thumbnail.#{format}")
      end

      def create(file, content_type, id, label = '')
        photo = Faraday::UploadIO.new(file, content_type)
        call(:post, 'photos.json', { photo: { file: photo, access_key: id, label: label}})
      end

      def delete(id)
        call(:delete, "photos/#{id}.json")
      end

      def image_opts(opts = {})
        opts = opts.with_indifferent_access
        format = opts.delete(:format) || 'json'
        raise ArgumentError, "#{format} is not an allowed format, use either 'json' or 'jpg'" unless ALLOWED_FORMATS.include?(format)
        format
      end
    end
  end
end
