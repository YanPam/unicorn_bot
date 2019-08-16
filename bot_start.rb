require 'telegram/bot'
require_relative 'order.rb'
require_relative 'registration.rb'
require_relative 'menu.rb'
require_relative 'recommend.rb'

class WebhooksController < Telegram::Bot::UpdatesController
  include Order
  include Registration
  include Menu
  include Recommrend
end

def initialize(*)
  super
    Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 1.month }
end

TOKEN = ENV['TOKEN']
bot = Telegram::Bot::Client.new(TOKEN)

require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start

