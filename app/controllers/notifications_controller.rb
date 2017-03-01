class NotificationsController < ApplicationController
   skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, only: [ :notify]



  def notify
    client = Twilio::REST::Client.new "AC9c90c239d635866df4956306ca511649", "377328e7e4bc40dd9a9d6d15817186b4"
    message = client.messages.create from: ' +15005550006', to: '+33 6 64 70 31 16', body: 'Learning to send SMS you are.'
    render plain: message.status
  end
end
