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

  # @param content text
  # @param type select { choices: ['notice', 'alert'], default: 'notice' }

  def playground(type: 'notice', content: 'This is the content')
    render(Flash::FlashComponent.new(type:).with_content(content))
  end
end
