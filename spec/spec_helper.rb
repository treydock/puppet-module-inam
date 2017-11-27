require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

at_exit { RSpec::Puppet::Coverage.report! }

add_custom_fact :service_provider, ->(os, facts) {
  case facts[:operatingsystemmajrelease]
  when '6'
    'redhat'
  else
    'systemd'
  end
}
