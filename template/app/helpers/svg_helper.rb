# frozen_string_literal: true

module SvgHelper
  def svg_tag(icon_name, options = {})
    file = Rails.root.join('app', 'assets', 'images', 'icons', "#{icon_name}.svg").read
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each { |attr, value| svg[attr.to_s] = value }

    doc.to_html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
