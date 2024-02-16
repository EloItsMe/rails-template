if Rails.env.development?
  Rails.application.config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = false
    Bullet.console       = false
    Bullet.rails_logger  = false
    Bullet.add_footer    = false
  end
end