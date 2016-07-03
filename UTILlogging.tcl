#******************************************************************************
# (C) 2016, Stefan Korner, Austria                                            *
#                                                                             *
# The Space Tcl Library is free software; you can redistribute it and/or      *
# modify it under the terms of the GNU Lesser General Public License as       *
# published by the Free Software Foundation; either version 2.1 of the        *
# License, or (at your option) any later version.                             *
#                                                                             *
# The Space Tcl Library is distributed in the hope that it will be useful,    *
# but WITHOUT ANY WARRANTY; without even the implied warranty of              *
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser     *
# General Public License for more details.                                    *
#******************************************************************************
# Logging facade with pluggable implementation                                *
#******************************************************************************
namespace eval UTIL {}

####################
# global variables #
####################
global UTIL::s_logger

##################
# default logger #
##################
proc UTIL::DEFAULT_LOGGER {logType message} {
  if {$logType == "I"} {
    puts "INFO: $message"
  } elseif {$logType == "W"} {
    puts "WARNING: $message"
  } elseif {$logType == "E"} {
    puts "ERROR: $message"
  } else {
    puts "$message"
  }
}
set UTIL::s_logger "::UTIL::DEFAULT_LOGGER"

#############
# functions #
#############
proc ::LOG {message} {
  global UTIL::s_logger
  $UTIL::s_logger "" $message
}

proc ::LOG_INFO {message} {
  global UTIL::s_logger
  $UTIL::s_logger "I" $message
}

proc ::LOG_WARNING {message} {
  global UTIL::s_logger
  $UTIL::s_logger "W" $message
}

proc ::LOG_ERROR {message} {
  global UTIL::s_logger
  $UTIL::s_logger "E" $message
}
