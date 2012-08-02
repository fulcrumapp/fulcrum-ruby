module Fulcrum
  class Record < Api

    class << self

      def all(opts = {})
        params = parse_opts([:page, :form_id, :bounding_box, :updated_since], opts)
        call(:get, 'records.json', params)
      end

      def find(id)
        call(:get, "records/#{id}.json")
      end

      def create(record)
        validation = RecordValidator.new(record)
        if validation.valid?
          call(:post, 'records.json', record)
        else
          { error: { validation: validation.errors } }
        end
      end

      def update(id, record)
        validation = RecordValidator.new(record)
        if validation.valid?
          call(:put, "records/#{id}.json", record)
        else
          { error: { validation: validation.errors } }
        end
      end

      def delete(id)
        call(:delete, "records/#{id}.json")
      end
    end
  end
end
