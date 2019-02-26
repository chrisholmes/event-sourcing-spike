# Event Sourcing Spike

Dependencies:
- ruby
- bundler

## How Does It Work?

This spike is heavily inspired by [Event Sourcing Made Simple](https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224) by Kickstarter.

The system is built from two types of objects:
- [Events](app/models/event.rb)
- [Aggregate](app/models/aggregate.rb)

Event objects represent the history of events that have happened in a system.
Event can be combined to produce an Aggregate object that can be used to
understand the current state of an entity in the system.

Unlike the Kickstarter example a single table is used for storing all events.

Specific events are implemented by inheriting from [Event](app/models/event.rb) through
ActiveRecord's support for [Single Table Inheritance](https://api.rubyonrails.org/classes/ActiveRecord/Inheritance.html). 

An association is made between an event and its aggregate using Rails' support
for [polymorphic associations](https://guides.rubyonrails.org/association_basics.html#polymorphic-associations).

Each event class must be designed to validate that the input it receives is
appropriate for the current aggregate state and goal of the action associated
with the event..

## What's modelled?

This spike simulates what would happen when a user uploads a certificate as part
of a group of other certificates.

The followings events are implemented:
- [CertificateGroup::CreationEvent](app/models/certificate_group/creation_event.rb) - creates a group that can hold certificates
- [Certificate::CreateEvent](app/models/certificate/create_event.rb) - creates certificates associated with with a group

The following aggregates are implemented:
- [CertificateGroup](app/models/certificate_group.rb)
- [Certificate](app/models/certificate.rb)

## Creating Events and Updating Aggregates

When an event is created a [callback](app/models/event.rb#L2) is used to ensure
that an [aggregate is updated](app/models/event.rb#L27).
If an aggregate object doesn't already exist then the event will
[create a new one](app/models/event.rb#L3). 

Classes that inherit from `Event` must override `#apply(aggregate)` to implement
the behaviour  needed to update the aggregate 
(e.g. [`Certificate::CreateEvent#apply(certificate)`](app/models/certificate/create_event.rb#L27)).

When an event is created it should use its validation callbacks to check that the
event can be applied to its associated aggregate. 

## Tests

[`spec/models/event_spec.rb`](spec/models/event_spec.rb) defines [RSpec shared examples](https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples) that can be applied to the classes that inherit from it. You can see examples of this at:
- [`spec/models/certificate/create_event_spec.rb`](spec/models/certificate/create_event_spec.rb)
- [`spec/models/certificate_group/creation_event_spec.rb`](spec/models/certificate_group/creation_event_spec.rb)
