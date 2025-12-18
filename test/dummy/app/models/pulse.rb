# frozen_string_literal: true

class Pulse
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName

  class << self
    delegate :broadcast_delayed_refresh_later, :enable!, to: :current
  end

  def self.current
    @current ||= new
  end

  private_class_method :new

  attribute :enabled, :boolean, default: false

  alias enabled? enabled

  def enable!
    return if enabled?

    self.enabled = true
    broadcast_delayed_refresh_later
  end

  def broadcast_delayed_refresh_later
    refresh_debouncer.debounce do
      BroadcastStreamJob.set(wait: 5.seconds).perform_later 'pulse', content: refresh_tag
    end
  end

  private

  def refresh_tag
    turbo_stream_refresh_tag request_id: Turbo.current_request_id
  end

  def refresh_debouncer
    refresh_debouncer_for self, request_id: Turbo.current_request_id
  end
end
