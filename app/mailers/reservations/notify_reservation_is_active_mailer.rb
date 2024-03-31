module Reservations
  class NotifyReservationIsActiveMailer < ApplicationMailer
    def notify(input)
      $logger.info "Reservations::NotifyReservationIsActiveMailer::notify - input: #{input}"
      @user = input[:reservation].user
      @reservation = input[:reservation]

      if input[:success]
        @subject = 'Your reservation is now active!'
        @body = "<h1>#{@user.first_name}! Your reservation has been confirmed.</h1>
          <p>The payment for your reservation with ID #{@reservation.id} is confirmed.</p>
          <p>Now your reservation is ACTIVE!</p>"
      else
        @subject = 'There was an error activating your reservation'
        @body = "<h1>Please contact support</h1>"
      end

      mail(
        to: @user.email,
        subject: @subject
      )
    end
  end
end
