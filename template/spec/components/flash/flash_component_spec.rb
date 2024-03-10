# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flash::FlashComponent, type: :component do
  it 'is render notice flash message' do
    render_inline(described_class.new(type: :notice).with_content('Hello, components!'))
    expect(page).to have_css('.flash.flash--notice', text: 'Hello, components!')
  end

  it 'is render alert flash message' do
    render_inline(described_class.new(type: :alert).with_content('Hello, components!'))
    expect(page).to have_css('.flash.flash--alert', text: 'Hello, components!')
  end

  it 'is raises an error for invalid type' do
    expect do
      render_inline(described_class.new(type: :invalid).with_content('Hello, components!'))
    end.to raise_error(ArgumentError)
  end
end
