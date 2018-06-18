require "fileutils"

require "./config/env_config_provider"
require "./config/optimal_count_config"
require "./prune/file_list_prune_service"
require "./file/list_files_service"
require "./email/email_sender"
require "./email/email_service"
require "./util/class_with_logger"

include ClassWithLogger

private def main
  config = read_configuration
  email_service = init_email_service(config)
  main_loop(config, email_service)
end

private def main_loop(config, email_service)
  last_email_sent_at = 0

  loop do
    logger.info("scanning directory #{config.directory}")
    prune_plan = get_prune_plan(config)
    logger.info("directory scanned, results: #{prune_plan.to_s}")

    delete_files_if_needed(config, prune_plan)
    if send_email_if_needed(config, email_service, prune_plan, last_email_sent_at)
      last_email_sent_at = get_time
    end

    logger.info("going to sleep for #{config.scan_interval} seconds")
    sleep(config.scan_interval)
  end
end

private def read_configuration
  logger.info("reading configuration")

  config_provider = EnvConfigProvider.new(ENV)
  config_provider.set_all

  unless config_provider.validation_errors.empty?
    logger.fatal(config_provider.validation_errors)
    exit( 1)
  end

  if config_provider.warnings.empty?
    logger.info("configuration OK")
  else
    logger.warn(config_provider.warnings)
  end

  config_provider.config
end

private def init_email_service(config)
  email_sender =
    EmailSender.new(
      config.smtp_hostname,
      config.smtp_port,
      config.smtp_domain,
      config.smtp_user,
      config.smtp_password,
      config.smtp_enable_ssl
    )

  EmailService.new(email_sender, config)
end

private def get_prune_plan(config)
  list_files_service = ListFilesService.new
  file_list_prune_service = FileListPruneService.new
  file_list_prune_service.execute(
      list_files_service.list_files(config.directory, Time.now),
    config.optimal_count_config
  )
end

private def delete_files_if_needed(config, prune_plan)
  if config.do_prune
    logger.info("going to delete #{prune_plan.elements_deleted.size} files")

    prune_plan.elements_deleted.each do |element|
      logger.info("deleting #{element.absolute_path}")

      begin
        FileUtils.rm(element.absolute_path)
        logger.info("deleted #{element.absolute_path}")
      rescue StandardError => ex
        logger.info("error deleting #{element.absolute_path}: #{ex}")
      end
    end

    unless prune_plan.elements_deleted.empty?
      logger.info("files deleted")
    end

  else
    logger.info("DO_PRUNE is false, so nothing will be deleted")
  end
end

private def send_email_if_needed(config, email_service, prune_plan, last_email_sent_at)
  if config.send_email
    time_now = get_time

    if prune_plan.elements_deleted.any? || (time_now - last_email_sent_at >= config.min_email_interval)
      logger.info("sending email")

      begin
        email_service.send(prune_plan)
        logger.info("email sent")
        return true
      rescue StandardError => ex
        logger.error("error sending email: #{ex}")
      end
    end
  else
    logger.info("SEND_EMAIL is false, so no email will be sent")
  end

  false
end

private def get_time
  Time.now.to_i
end

main