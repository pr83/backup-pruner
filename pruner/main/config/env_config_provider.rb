require "active_support/core_ext/hash/indifferent_access"
require "./config/config"
require "./config/boolean_parser"
require "./config/interval_parser"
require "./config/optimal_count_config"

class EnvConfigProvider

  DEFAULT_SCAN_INTERVAL = 60 * 60 * 12
  DEFAULT_EMAIL_SUBJECT = "Prune results"
  SMTP_SSL_PORT = 465

  attr_reader(
    :config,
    :validation_errors,
    :warnings
  )

  def initialize(env = ENV)
    @env = env.to_hash.with_indifferent_access
    @validation_errors = []
    @config = Config.new
  end

  def set_all
    set_optimal_count_config
    set_directory
    set_scan_interval
    set_do_prune
    set_send_email
    set_smtp_hostname
    set_smtp_domain
    set_smtp_port
    set_smtp_user
    set_smtp_password
    set_smtp_enable_ssl
    set_email_from
    set_email_to
    set_email_subject
    set_min_email_interval

    post_validation
  end

  def set_optimal_count_config
    field_name = :OPTIMAL_COUNT_CONFIG

    field_value = @env[field_name]

    unless test_mandatory_parameter(field_name, field_value)
      return
    end

    if field_value.to_s.empty?
      add_validation_error(field_name, field_value, "Parameter is mandatory.")
      return
    end

    begin
      @config.optimal_count_config = OptimalCountConfig.new(field_value).config
    rescue StandardError => ex
      add_validation_error(field_name, field_value, ex)
    end
  end

  def set_directory
    field_name = :DIRECTORY
    field_value = @env[field_name]

    unless test_mandatory_parameter(field_name, field_value)
      return
    end

    unless File.directory?(field_value)
      add_validation_error(field_name, field_value, "Not a valid directory.")
      return
    end

    @config.directory = field_value
  end

  def set_do_prune
    field_name = :DO_PRUNE
    field_value = @env[field_name]
    @config.do_prune = BooleanParser.new.parse(field_value)
  end

  def set_scan_interval
    field_name = :SCAN_INTERVAL
    field_value = @env[field_name]

    if field_value.to_s.empty?
      @config.scan_interval = DEFAULT_SCAN_INTERVAL
      return
    end

    begin
      @config.scan_interval = IntervalParser.new(field_value).parse
    rescue StandardError => ex
      add_validation_error(field_name, field_value, ex)
    end
  end

  def set_send_email
    field_name = :SEND_EMAIL
    field_value = @env[field_name]
    @config.send_email = BooleanParser.new.parse(field_value)
  end

  def set_smtp_hostname
    unless @config.send_email
      return
    end

    @config.smtp_hostname = get_string(:SMTP_HOSTNAME, @config.send_email)
  end

  def set_smtp_port
    unless @config.send_email
      return
    end

    field_name = :SMTP_PORT

    field_value = @env[field_name]
    if field_value == nil || !(field_value =~ /^[[:digit:]]+$/)
      add_validation_error(field_name, field_value, "Must be a valid integer.")
      return
    end

    port_as_integer = field_value.to_i
    if port_as_integer < 0 || port_as_integer > 65535
      add_validation_error(field_name, field_value, "Must be between 0 and 65535.")
      return
    end

    @config.smtp_port = port_as_integer
  end

  def set_smtp_domain
    unless @config.send_email
      return
    end

    @config.smtp_domain = get_string(:SMTP_DOMAIN, @config.send_email)
  end

  def set_smtp_user
    unless @config.send_email
      return
    end

    @config.smtp_user = get_string(:SMTP_USER, @config.send_email)
  end

  def set_smtp_password
    unless @config.send_email
      return
    end

    @config.smtp_password = get_string(:SMTP_PASSWORD, @config.send_email)
  end

  def set_email_from
    unless @config.send_email
      return
    end

    @config.email_from = get_string(:EMAIL_FROM, @config.send_email)
  end

  def set_smtp_enable_ssl
    field_name = :SMTP_ENABLE_SSL
    field_value = @env[field_name]
    @config.smtp_enable_ssl = BooleanParser.new.parse(field_value)
  end

  def set_email_to
    unless @config.send_email
      return
    end

    @config.email_to = get_string(:EMAIL_TO, @config.send_email)
  end

  def set_email_subject
    unless @config.send_email
      return
    end

    @config.email_subject = @env[:EMAIL_SUBJECT] || DEFAULT_EMAIL_SUBJECT
  end

  def set_min_email_interval
    unless @config.send_email
      return
    end

    field_name = :LONGEST_DELAY_BETWEEN_EMAILS

    field_value = @env[field_name]

    if field_value.to_s.empty?
      @config.min_email_interval = @config.scan_interval
      return
    end

    begin
      @config.min_email_interval = IntervalParser.new(field_value).parse
    rescue StandardError => ex
      add_validation_error(field_name, field_value, ex)
    end
  end

  def post_validation
    @warnings = []

    if @config.send_email && !@config.smtp_enable_ssl && @config.smtp_port == SMTP_SSL_PORT
      @warnings.push(
        "SMTP is configured to use port #{SMTP_SSL_PORT}, which is normally used for SMTP with SSL,
        but SSL is not enabled by the SMTP_ENABLE_SSL environment variable being 'true'. Sending emails
        will likely fail."
      )
    end
  end

  private def get_string(field_name, mandatory)
    field_value = @env[field_name]
    if mandatory && !test_mandatory_parameter(field_name, field_value)
      return
    end
    field_value
  end

  private def test_mandatory_parameter(field_name, field_value)
    if field_value.to_s.empty?
      add_validation_error(field_name, field_value, "Parameter is mandatory.")
      return false
    end
    true
  end

  private def add_validation_error(field_name, field_value, message)
    @validation_errors.push("Invalid value for field #{field_name}: '#{field_value}'. #{message}")
  end

end
