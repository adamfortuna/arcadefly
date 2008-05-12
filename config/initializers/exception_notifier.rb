# Add the emails which should receive exception notifications below.  ie: %W(admin1@yoursite.com admin2@yoursite.com)


ExceptionNotifier.sender_address =  %("ArcadeFly <outgoing@arcadefly.com>")
ExceptionNotifier.exception_recipients = %W("ArcadeFly Errors <error@arcadefly.com>")
ExceptionNotifier.email_prefix = "[ArcadeFly.com Exception] "