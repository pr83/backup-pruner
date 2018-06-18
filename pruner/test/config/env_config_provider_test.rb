require "test/unit"
require './config/env_config_provider'

class EnvConfigProviderTest < Test::Unit::TestCase

  def test_optimal_count
    env = {"OPTIMAL_COUNT_CONFIG" => "1s: 5"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_optimal_count_config
    expected = [OptimalCountAgo.new(1, 5)]

    actual = config_provider.config.optimal_count_config

    assert_equal(expected, actual)
  end

  def test_optimal_count_config_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_optimal_count_config
    actual = config_provider.validation_errors
    expected =
        ["Invalid value for field OPTIMAL_COUNT_CONFIG: ''. Parameter is mandatory."]
    assert_equal(expected, actual)
  end

  def test_optimal_count_config_error
    env = {"OPTIMAL_COUNT_CONFIG" => "1dx: 5"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_optimal_count_config
    actual = config_provider.validation_errors
    expected =
        ["Invalid value for field OPTIMAL_COUNT_CONFIG: '1dx: 5'. Invalid unit 'dx' at position 3 in '1dx'."]
    assert_equal(expected, actual)
  end

  def test_directory_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_directory
    actual = config_provider.validation_errors
    expected =
        ["Invalid value for field DIRECTORY: ''. Parameter is mandatory."]
    assert_equal(expected, actual)
  end

  def test_directory_does_not_exist
    env = {"DIRECTORY" => "/does/not/exist"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_directory
    actual = config_provider.validation_errors
    expected =
        ["Invalid value for field DIRECTORY: '/does/not/exist'. Not a valid directory."]
    assert_equal(expected, actual)
  end

  def test_scan_interval
    env = {"SCAN_INTERVAL" => "1s"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_scan_interval
    expected = 1

    actual = config_provider.config.scan_interval

    assert_equal(expected, actual)
  end

  def test_scan_interval_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_scan_interval
    expected = 60 * 60 * 12

    actual = config_provider.config.scan_interval

    assert_equal(expected, actual)
  end

  def test_scan_interval_validation_error
    env = {"SCAN_INTERVAL" => "1x"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_scan_interval
    expected = ["Invalid value for field SCAN_INTERVAL: '1x'. Invalid unit 'x' at position 2 in '1x'."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_do_prune
    env = {"DO_PRUNE" => "true"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_do_prune
    expected = true

    actual = config_provider.config.do_prune

    assert_equal(expected, actual)
  end

  def test_do_prune_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_do_prune
    expected = false

    actual = config_provider.config.do_prune

    assert_equal(expected, actual)
  end

  def test_send_email
    env = {"SEND_EMAIL" => "true"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_send_email
    expected = true

    actual = config_provider.config.send_email

    assert_equal(expected, actual)
  end

  def test_send_email_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_send_email
    expected = false

    actual = config_provider.config.send_email

    assert_equal(expected, actual)
  end

  def test_smtp_hostname
    expected = "example.com"
    env = {"SMTP_HOSTNAME" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_hostname
    expected = expected

    actual = config_provider.config.smtp_hostname

    assert_equal(expected, actual)
  end

  def test_smtp_hostname_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_hostname
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_hostname_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_hostname
    expected = ["Invalid value for field SMTP_HOSTNAME: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_domain
    expected = "example.com"
    env = {"SMTP_DOMAIN" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_domain

    actual = config_provider.config.smtp_domain

    assert_equal(expected, actual)
  end

  def test_smtp_domain_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_domain
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_domain_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_domain
    expected = ["Invalid value for field SMTP_DOMAIN: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_user
    expected = "john"
    env = {"SMTP_USER" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_user

    actual = config_provider.config.smtp_user

    assert_equal(expected, actual)
  end

  def test_smtp_user_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_user
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_user_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_user
    expected = ["Invalid value for field SMTP_USER: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_password
    expected = "Pa$$w0rd"
    env = {"SMTP_PASSWORD" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_password

    actual = config_provider.config.smtp_password

    assert_equal(expected, actual)
  end

  def test_smtp_password_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_password
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_password_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_password
    expected = ["Invalid value for field SMTP_PASSWORD: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_email_from
    expected = "test@mailinator.com"
    env = {"EMAIL_FROM" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_from

    actual = config_provider.config.email_from

    assert_equal(expected, actual)
  end

  def test_email_from_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_email_from
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_email_from_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_from
    expected = ["Invalid value for field EMAIL_FROM: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_email_to
    expected = "test@mailinator.com"
    env = {"EMAIL_TO" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_to

    actual = config_provider.config.email_to

    assert_equal(expected, actual)
  end

  def test_email_to_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_email_to
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_email_to_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_to
    expected = ["Invalid value for field EMAIL_TO: ''. Parameter is mandatory."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_email_subject
    expected = "Test"
    env = {"EMAIL_SUBJECT" => expected}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_subject

    actual = config_provider.config.email_subject

    assert_equal(expected, actual)
  end

  def test_email_subject_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_email_subject
    expected = "Prune results"

    actual = config_provider.config.email_subject

    assert_equal(expected, actual)
  end

  def test_smtp_port
    expected = 1234
    env = {"SMTP_PORT" => expected.to_s}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_port

    actual = config_provider.config.smtp_port

    assert_equal(expected, actual)
  end

  def test_smtp_port_empty_not_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_port
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_port_empty_sending_email
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_port
    expected = ["Invalid value for field SMTP_PORT: ''. Must be a valid integer."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_port_out_of_range_sending_email
    env = {"SMTP_PORT" => "999999"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_smtp_port
    expected = ["Invalid value for field SMTP_PORT: '999999'. Must be between 0 and 65535."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_smtp_enable_ssl
    env = {"SMTP_ENABLE_SSL" => "true"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_enable_ssl
    expected = true

    actual = config_provider.config.smtp_enable_ssl

    assert_equal(expected, actual)
  end

  def test_smtp_enable_ssl_false
    env = {"SMTP_ENABLE_SSL" => "false"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_enable_ssl
    expected = false

    actual = config_provider.config.smtp_enable_ssl

    assert_equal(expected, actual)
  end

  def test_smtp_enable_ssl_empty
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_smtp_enable_ssl
    expected = []

    assert_false config_provider.config.smtp_enable_ssl
    assert_equal(expected, config_provider.validation_errors)
  end

  def test_min_email_interval
    env = {"LONGEST_DELAY_BETWEEN_EMAILS" => "1d"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_min_email_interval
    expected = 60 * 60 * 24

    actual = config_provider.config.min_email_interval

    assert_equal(expected, actual)
  end

  def test_min_email_interval_empty_email_not_sent
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_min_email_interval
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_min_email_interval_empty_email_sent
    env = {}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_scan_interval
    config_provider.set_min_email_interval
    expected = 60 * 60 * 12

    actual = config_provider.config.min_email_interval

    assert_equal(expected, actual)
  end

  def test_min_email_interval_invalid_email_not_sent
    env = {"LONGEST_DELAY_BETWEEN_EMAILS" => "xx"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.set_min_email_interval
    expected = []

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

  def test_min_email_interval_invalid_email_sent
    env = {"LONGEST_DELAY_BETWEEN_EMAILS" => "xx"}
    config_provider = EnvConfigProvider.new(env)
    config_provider.config.send_email = true
    config_provider.set_min_email_interval
    expected = ["Invalid value for field LONGEST_DELAY_BETWEEN_EMAILS: 'xx'. Invalid character at position 0 in 'xx'."]

    actual = config_provider.validation_errors

    assert_equal(expected, actual)
  end

end
