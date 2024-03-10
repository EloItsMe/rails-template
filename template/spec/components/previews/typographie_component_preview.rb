# frozen_string_literal: true

class TypographieComponentPreview < ViewComponent::Preview
  # @!group Preview
  #
  # This is just a preview of the component dont use it in your code use standard HTML instead
  # ----------------
  #
  def title_l
    render(Typographie::TypographieComponent.new(style: 'title--l'))
  end

  def title
    render(Typographie::TypographieComponent.new(style: 'title'))
  end

  def title_s
    render(Typographie::TypographieComponent.new(style: 'title--s'))
  end

  def subtitle
    render(Typographie::TypographieComponent.new(style: 'subtitle'))
  end

  def paragraph_l
    render(Typographie::TypographieComponent.new(style: 'paragraph--l'))
  end

  def paragraph
    render(Typographie::TypographieComponent.new(style: 'paragraph'))
  end

  def paragraph_s
    render(Typographie::TypographieComponent.new(style: 'paragraph--s'))
  end

  def paragraph_xs
    render(Typographie::TypographieComponent.new(style: 'paragraph--xs'))
  end

  def paragraph_xxs
    render(Typographie::TypographieComponent.new(style: 'paragraph--xxs'))
  end
  # @!endgroup

  # @!group Playground
  #
  # This is just a preview of the component dont use it in your code use standard HTML instead
  # ----------------
  #
  # @param style select "className to apply" { choices: ["title--l", "title", "title--s", "subtitle", "paragraph--l", "paragraph", "paragraph--s", "paragraph--xs", "paragraph--xxs"] } # rubocop:disable Layout/LineLength
  def playground(style: 'title--l')
    render(Typographie::TypographieComponent.new(style:))
  end

  # @!endgroup
end
