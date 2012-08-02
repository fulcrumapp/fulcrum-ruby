module Fulcrum
  class ChoiceList < Api

    class << self

      def all(opts = {})
        params = parse_opts([:page], opts)
        call(:get, 'choice_lists.json', params)
      end

      def find(id)
        call(:get, "choice_lists/#{id}.json")
      end

      def create(choice_list)
        validation = ChoiceListValidator.new(choice_list)
        if validation.valid?
          call(:post, 'choice_lists.json', choice_list)
        else
          { error: { validation: validation.errors } }
        end
      end

      def update(id, choice_list)
        validation = ChoiceListValidator.new(choice_list)
        if validation.valid?
          call(:put, "choice_lists/#{id}.json", choice_list)
        else
          { error: { validation: validation.errors } }
        end
      end

      def delete(id)
        call(:delete, "choice_lists/#{id}.json")
      end
    end
  end
end
