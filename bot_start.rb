require 'telegram/bot'
require 'time'
require 'redis'
require 'active_support/all'
require 'faraday'
require 'pry'
require_relative 'order.rb'
require_relative 'start.rb'
require_relative 'menu.rb'
require_relative 'recommend.rb'


class WebhooksController < Telegram::Bot::UpdatesController
  BASE_URL = 'http://localhost:3000'

  include Telegram::Bot::UpdatesController::MessageContext

  include Start
  include Menu
  include Order
  include Recommend

  MSG = {
  	success_registration: 'Registration done',
  	already_registered:'No need to register again',
  }.freeze

  def notify(msg_key)
    respond_with :message, text: MSG[msg_key]
  end

  def registered?
    session.key?(:id)
  end

  def initialize(*)
    @http_client = Faraday.new(:url => BASE_URL) 
    super
    Telegram::Bot::UpdatesController.session_store = :redis_store, { expires_in: 1.month }
  end
end


TOKEN = ENV['TOKEN']
bot = Telegram::Bot::Client.new(TOKEN)

require 'logger'
logger = Logger.new(STDOUT)
poller = Telegram::Bot::UpdatesPoller.new(bot, WebhooksController, logger: logger)
poller.start

