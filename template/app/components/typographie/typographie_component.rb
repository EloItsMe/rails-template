# frozen_string_literal: true

module Typographie
  class TypographieComponent < ViewComponent::Base
    def initialize(style:)
      super
      @style = style
    end
  end
end
