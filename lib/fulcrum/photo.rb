module Fulcrum
  class Photo < Api

    ALLOWED_FORMATS = %w(json jpg)
    ALLOWED_IMAGE_TYPES = %(png jpg)

    class << self

      def find(id, opts = {})
        opts = opts.with_indifferent_access
        format = opts.delete(:format) || 'jpg'
        raise ArgumentError, "#{format} is not an allowed format, use either 'json' or 'jpg'" unless ALLOWED_FORMATS.include?(format)
        call(:get, "photos/#{id}.#{format}")
      end

      def thumbnail(id)
        call(:get, "photos/#{id}/thumbnail.jpg")
      end

      def create(file, content_type, id, label = '')
        photo = Faraday::UploadIO.new(file, content_type)
        call(:post, 'photos.json', { photo: { file: photo, access_key: id, label: label}})
      end

      def delete(id)
        call(:delete, "photos/#{id}.json")
      end
    end
  end
end
