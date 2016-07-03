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
# helpers for unit tests                                                      *
#******************************************************************************

# converts binary data to hex data
proc bin2hex {binData} {
  set hexData ""
  set binLen [string length $binData]
  for {set i 0} {$i < $binLen} {incr i} {
    set binByte [string index $binData $i]
    set hexByte [format %02X [scan $binByte %c]]
    append hexData $hexByte 
  }
  return $hexData
}
