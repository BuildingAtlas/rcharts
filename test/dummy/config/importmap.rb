# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
