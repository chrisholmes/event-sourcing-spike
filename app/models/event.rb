class Event < ActiveRecord::Base
  before_create :update_aggregate
  before_validation :preset_aggregate
  self.abstract_class = true

  def self.aggregated_with(aggregate_name)
    @aggregate_name = aggregate_name
    belongs_to aggregate_name
    define_method :aggregate_name do
      aggregate_name
    end
  end

  def aggregate
    public_send aggregate_name
  end

  def aggregate=(aggregate)
    public_send "#{aggregate_name}=", aggregate
  end

  def aggregate_id
    public_send "#{aggregate_name}_id"
  end
  def aggregate_id=(id)
    public_send "#{aggregate_name}_id=", id
  end

  def build_aggregate
    public_send "build_#{aggregate_name}"
  end

  def apply(aggregate)
    raise NotImplementedError
  end

  def update_aggregate
    self.aggregate = apply(aggregate)

    self.aggregate.save!
    self.aggregate_id = aggregate.id if aggregate_id.nil?
  end

  def preset_aggregate
    self.aggregate ||= build_aggregate
  end
end
