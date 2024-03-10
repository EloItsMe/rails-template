# frozen_string_literal: true

module Form
  module Input
    class InputComponent < ViewComponent::Base
      def initialize(type: :string, label: '', placeholder: '', hint: '', error: '', disabled: false) # rubocop:disable Metrics/ParameterLists
        super
        @type = type.to_sym
        @label = label
        @placeholder = placeholder
        @hint = hint
        @error = error
        @disabled = disabled
      end
    end
  end
end
