# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :default, class: :input__wrapper do |b|
    b.use :html5
    b.use :placeholder
    b.use :maxlength
    b.use :minlength
    b.use :pattern
    b.use :min_max
    b.use :readonly
    b.use :label, class: 'form__text--label'
    b.use :input, class: 'form__input', error_class: :invalid, valid_class: :valid
    b.use :hint,  wrap_with: { tag: :span, class: 'form__text--hint' }
    b.use :error, wrap_with: { tag: :span, class: 'form__text--error' }
  end

  config.default_wrapper = :default
  config.boolean_style = :inline
  config.button_class = 'btn btn--primary'
  config.collection_wrapper_tag = :div
  config.collection_wrapper_class = nil
  config.item_wrapper_tag = nil
  config.label_text = ->(label, required, _explicit_label) { "#{required} #{label}" }
  config.generate_additional_classes_for = []
  config.browser_validations = false
  # config.i18n_scope = 'simple_form'
end
