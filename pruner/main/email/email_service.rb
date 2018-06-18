require "./email/email_sender"
require "./email/email_formatter"

class EmailService

  def initialize(email_sender, config)
    @email_sender = email_sender
    @config = config
  end

  def send(prune_plan)
    @email_sender.send(
      @config.email_from,
      @config.email_to,
      @config.email_subject,
      EmailFormatter.new.format(prune_plan, @config)
    )
  end

end
