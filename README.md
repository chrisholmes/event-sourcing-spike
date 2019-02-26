# Event Sourcing Spike

Dependencies:
- ruby
- bundler

## How Does It Work?

This spike is heavily inspired by [Event Sourcing Made Simple](https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224) by Kickstarter.

The system is built from two types of objects:
- [Events](app/models/event.rb)
- [Aggregate](app/models/aggregate.rb)

Event objects represent actions that happen in a system that when combined will
produce an Aggregate object.

The intention is that an instance of Event class will be to used to receive the
inputs from a user when an action occurs.

Each event class will be designed to validate that the input it receives is
appropriate against the current aggregate state as well as the aims of that
action.

This spike simulates what would happen when a user uploads a certificate as part
of a group of other certificates.

The followings events are implemented:
- [CertificateGroup::CreationEvent](app/models/certificate_group/creation_event.rb) - creates a group that can hold certificates
- [Certificate::CreateEvent](app/models/certificate/create_event.rb) - creates certificates associated with with a group

The following aggregates are implemented:
- [CertificateGroup](app/models/certificate_group.rb)
- [Certificate](app/models/certificate.rb)

## Creating Events and Updating Aggregates

When an event is created a callback is used to ensure that an aggregate is
updated. If an aggregate object doesn't already exist then the event will
create a new one.

When an event is create should use its validation callbacks to check that the
event can be applied to its associated aggregate. 

## Tests

[`spec/models/event_spec.rb`](spec/models/event_spec.rb) defines [RSpec shared examples](https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-examples) that can be applied to the classes that inherit from it. You can see examples of this at:
- [`spec/models/certificate/create_event_spec.rb`](spec/models/certificate/create_event_spec.rb)
- [`spec/models/certificate_group/creation_event_spec.rb`](spec/models/certificate_group/creation_event_spec.rb)
