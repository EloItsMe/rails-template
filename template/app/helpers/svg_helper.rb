# frozen_string_literal: true

module SvgHelper
  def show_svg(name)
    file_path = Rails.root.join("app/assets/images/icons/#{name}.svg").to_s
    return File.read(file_path).html_safe if File.exist?(file_path) # rubocop:disable Rails/OutputSafety

    '(not found)'
  end
end
