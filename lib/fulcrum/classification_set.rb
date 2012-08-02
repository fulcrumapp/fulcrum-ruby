module Fulcrum
  class ClassificationSet < Api

    class << self

      def all(opts = {})
        params = parse_opts([:page], opts)
        call(:get, 'classification_sets.json', params)
      end

      def find(id)
        call(:get, "classification_sets/#{id}.json")
      end

      def create(classification_set)
        validation = ClassificationSetValidator.new(classification_set)
        if validation.valid?
          call(:post, 'classification_sets.json', classification_set)
        else
          { error: { validation: validation.errors } }
        end
      end

      def update(id, classification_set)
        validation = ClassificationSetValidator.new(classification_set)
        if validation.valid?
          call(:put, "classification_sets/#{id}.json", classification_set)
        else
          { error: { validation: validation.errors } }
        end
      end

      def delete(id)
        call(:delete, "classification_sets/#{id}.json")
      end
    end

  end
end
