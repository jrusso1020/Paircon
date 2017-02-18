class Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp} #{severity} (#{$$}) #{msg}\n"
  end
end
