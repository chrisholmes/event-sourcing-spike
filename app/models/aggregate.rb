class Aggregate < ApplicationRecord
  self.abstract_class = true

  def self.creation_event_class
    raise NotImplementedError
  end

  def self.create(*args)
    event = creation_event_class.create(*args)
    event.aggregate
  end

  has_many :events
end
