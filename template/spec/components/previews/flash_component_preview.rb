# frozen_string_literal: true

class FlashComponentPreview < ViewComponent::Preview
  # @!group Preview

  def notice
    render(Flash::FlashComponent.new(type: 'notice').with_content('This is a notice'))
  end

  def alert
    render(Flash::FlashComponent.new(type: 'alert').with_content('This is an alert'))
  end

  # @!endgroup

  # @param type select "Type of flash" { choices: ["notice", "alert"] }
  # @param content text "Content of flash"
  def playground(type: 'notice', content: 'This is a notice')
    render(Flash::FlashComponent.new(type:).with_content(content))
  end
end
