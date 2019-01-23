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
