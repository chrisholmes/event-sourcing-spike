class Event < ActiveRecord::Base
  before_create :update_aggregate
  before_validation :preset_aggregate
  after_initialize :default_values

  def self.aggregated_with(aggregate_name)
    @aggregate_name = aggregate_name
    belongs_to :aggregate, polymorphic: true, autosave: false
    define_method :aggregate_name do
      aggregate_name
    end
    alias_attribute aggregate_name, :aggregate
  end

  private def default_values
    self.data ||= {}
  end

  def preset_aggregate
    self.aggregate ||= build_aggregate
  end

  def build_aggregate
    public_send "build_#{aggregate_name}"
  end

  def update_aggregate
    # Lock! (all good, we're in the ActiveRecord callback chain transaction)
    aggregate.lock! if aggregate.persisted?

    self.aggregate = apply(aggregate)

    aggregate.save!
    self.aggregate_id = aggregate.id if aggregate_id.nil?
  end


  def apply(aggregate)
    raise NotImplementedError
  end

  def self.data_attributes(*names)
    names.each do |name|
      define_method name do 
        self.data ||= {}
        self.data[name.to_s]
      end
      define_method "#{name}=" do |value|
        self.data ||= {}
        self.data[name.to_s] = value
      end
    end
  end

  def self.aggregate_belongs_to(name)
    data_attributes "#{name}_id", "#{name}_type"

    define_method name do
      instance_variable_get(("@#{name}").intern) || send("load_#{name}_from_id")
    end

    define_method "#{name}=" do |value|
      instance_variable_set(("@#{name}").intern, value)
      public_send("#{name}_id=", value.id)
      public_send("#{name}_type=", value.class.name)
    end

    define_method "load_#{name}_from_id" do
      if send("#{name}_id").nil? || send("#{name}_type").nil?
        return nil
      else
        send("#{name}_type").constantize.find(send("#{name}_id"))
      end
    end
  end
end
