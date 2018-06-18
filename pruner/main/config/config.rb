require "./util/class_decorator"

class Config

  include ClassDecorator

  attr_accessor(
    :optimal_count_config,
    :directory,
    :scan_interval,
    :do_prune,
    :send_email,
    :smtp_hostname,
    :smtp_port,
    :smtp_domain,
    :smtp_user,
    :smtp_password,
    :smtp_enable_ssl,
    :email_from,
    :email_to,
    :email_subject,
    :min_email_interval
  )

end
