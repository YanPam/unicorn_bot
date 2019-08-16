require 'telegram/bot'
require 'time'
require 'redis'
require 'active_support/all'
require_relative 'order.rb'
require_relative 'start.rb'
require_relative 'menu.rb'
require_relative 'recommend.rb'

class WebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Start
  include Menu
  include Order
  include Recommend

end

Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 1.month }


TOKEN = ENV['TOKEN']
bot = Telegram::Bot::Client.new(TOKEN)

require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start

