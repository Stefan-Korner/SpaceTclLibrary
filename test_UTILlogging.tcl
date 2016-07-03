#!/bin/sh
# \
exec tclsh "$0" ${1+"$@"}
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
# unit tests for logging                                                      *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex

# test default logger
LOG "--> normal log"
LOG_INFO "--> info log"
LOG_WARNING "--> warning log"
LOG_ERROR "--> error log"

# plug in user defined logger
proc CUSTOM_LOGGER {logType message} {
  if {$logType == "I"} {
    puts "CUSTOM - INFO: $message"
  } elseif {$logType == "W"} {
    puts "CUSTOM - WARNING: $message"
  } elseif {$logType == "E"} {
    puts "CUSTOM ERROR: $message"
  } else {
    puts "CUSTOM $message"
  }
}
set UTIL::s_logger "::CUSTOM_LOGGER"
# test user defined logger
LOG "--> normal log"
LOG_INFO "--> info log"
LOG_WARNING "--> warning log"
LOG_ERROR "--> error log"
