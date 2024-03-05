# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(_auth_object = nil)
    super
  end

  def self.ransackable_associations(_auth_object = nil)
    super
  end
end
