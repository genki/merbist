class LoggingAdhocStore < Merb::Cache::AdhocStore
  include Extlib::Hook

  before :read do |key, params|
    state = exists?(key, params) ? 'Hit' : 'Miss'
    Merb.logger.debug "Cache #{state}: #{key}"
  end

  before :write do |key, data, params, conds|
    Merb.logger.debug "Cache Write: #{key}"
  end

  before :write_all do |key, data, params, conds|
    Merb.logger.debug "Cache Write All: #{key}"
  end

  before :delete do |key, params|
    Merb.logger.debug "Cache Expire: #{key}"
  end

  before :delete_all do |key, params|
    Merb.logger.debug "Cache Expire All: #{key}"
  end
end
