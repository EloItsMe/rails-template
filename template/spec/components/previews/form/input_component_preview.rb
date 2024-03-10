# frozen_string_literal: true

module Form
  class InputComponentPreview < ViewComponent::Preview
    # @!group Preview
    def string_input
      render(Form::Input::InputComponent.new(type: 'string', label: 'String', placeholder: 'String',
                                             hint: 'This is a hint'))
    end

    def email_input
      render(Form::Input::InputComponent.new(type: 'email', label: 'Email', placeholder: 'Email',
                                             hint: 'This is a hint'))
    end

    def url_input
      render(Form::Input::InputComponent.new(type: 'url', label: 'URL', placeholder: 'URL',
                                             hint: 'This is a hint'))
    end

    def password_input
      render(Form::Input::InputComponent.new(type: 'password', label: 'Password', placeholder: 'Password',
                                             hint: 'This is a hint'))
    end

    def search_input
      render(Form::Input::InputComponent.new(type: 'search', label: 'Search', placeholder: 'Search',
                                             hint: 'This is a hint'))
    end

    def text_input
      render(Form::Input::InputComponent.new(type: 'text', label: 'Text', placeholder: 'Text',
                                             hint: 'This is a hint'))
    end

    def integer_input
      render(Form::Input::InputComponent.new(type: 'integer', label: 'Integer', placeholder: 'Integer',
                                             hint: 'This is a hint'))
    end

    # @!endgroup

    # @param type select "Type of input" { choices: ["string", "email", "password", "integer", "date", "text"] }
    # @param label text "Label"
    # @param placeholder text "Placeholder"
    # @param hint text "Hint"
    # @param error text "Error"
    # @param disabled toggle "Disabled"
    def playground(type: 'string', label: 'Label', placeholder: 'Placeholder', hint: 'Hint', error: 'Error', # rubocop:disable Metrics/ParameterLists
                   disabled: false)
      render(Form::Input::InputComponent.new(type:, label:, placeholder:, hint:,
                                             error:, disabled:))
    end
  end
end
