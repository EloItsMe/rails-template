if Rails.env.development?
  Rails.application.config.view_component.generate.preview = true
  Rails.application.config.view_component.preview_paths << "spec/components/previews"
  Rails.application.config.view_component.default_preview_layout = 'component'
end