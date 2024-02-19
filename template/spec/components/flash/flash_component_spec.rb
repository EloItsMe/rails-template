# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flash::FlashComponent, type: :component do
  it 'render a flash message' do
    render_inline(described_class.new(type: 'notice')) { 'This is a notice' }
    expect(page).to have_css('.flash.flash--notice', text: 'This is a notice')
  end

  it 'render an alert message' do
    render_inline(described_class.new(type: 'alert')) { 'This is an alert' }
    expect(page).to have_css('.flash.flash--alert', text: 'This is an alert')
  end
end
