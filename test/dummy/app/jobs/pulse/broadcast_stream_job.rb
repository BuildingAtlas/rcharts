# frozen_string_literal: true

class Pulse
  class BroadcastStreamJob < Turbo::Streams::BroadcastStreamJob
    after_perform -> { Pulse.broadcast_delayed_refresh_later }
  end
end
