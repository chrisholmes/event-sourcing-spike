class Aggregate < ApplicationRecord
  self.abstract_class = true

  def self.creation_event_class
      raise NotImplementedError
  end

  alias_method :save_from_event!, :save!

  ActiveRecord::Persistence.public_instance_methods.reject do |sym|
    sym.to_s.end_with?('?')
  end.each do |method|
    define_method method do |*args|
      raise "#{method} is not available for #{self.class} called by #{caller}"
    end
  end

  def self.create(*args)
    event = creation_event_class.create(*args)
    event.aggregate
  end

  has_many :events
end
