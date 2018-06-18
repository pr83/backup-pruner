require "net/smtp"
require "./email/email_formatter"

class EmailSender

  def initialize(
      smtp_server_hostname, smtp_server_port, smtp_server_domain, smtp_server_user, smtp_server_password, enable_ssl)
    @smtp_server_hostname = smtp_server_hostname
    @smtp_server_port = smtp_server_port
    @smtp_server_domain = smtp_server_domain
    @smtp_server_user = smtp_server_user
    @smtp_server_password = smtp_server_password
    @enable_ssl = enable_ssl
  end

  def send(from, to, subject, body)
    smtp = Net::SMTP.new @smtp_server_hostname, @smtp_server_port

    if @enable_ssl
      ssl_context = Net::SMTP.default_ssl_context
      ssl_context.set_params({verify_mode: OpenSSL::SSL::VERIFY_NONE})
      smtp.enable_tls(ssl_context)
    end

    smtp.start @smtp_server_domain, @smtp_server_user, @smtp_server_password, :login do
      smtp.send_message(create_message(subject, from, to, body), from, to)
    end
  end

  def create_message(subject, from, to, body)
    "Subject: #{subject}\nContent-Type: text/html\nFrom: #{from}\nTo: #{to}\n\n" + body
  end

end
