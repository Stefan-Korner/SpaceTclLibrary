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
# helpers                                                                     *
#******************************************************************************

# converts binary data to hex data
proc bin2hex {binData} {
  binary scan $binData H* hexData
  return $hexData
}

# converts hex data to binary data
proc hex2bin {hexData} {
  return [binary format H* $hexData]
}

# converts list data to hex data
proc lst2hex {lstData} {
  set hexData ""
  foreach {datum} $lstData {
    append hexData [format "%02x" $datum]
  }
  return $hexData
}

# converts hex data to list data
proc hex2lst {hexData} {
  array set hexHighMap {
    48 0x00 49 0x10 50 0x20 51 0x30 52 0x40  53 0x50  54 0x60  55 0x70
    56 0x80 57 0x90 65 0xa0 66 0xb0 67 0xc0  68 0xd0  69 0xe0  70 0xf0
                    97 0xa0 98 0xb0 99 0xc0 100 0xd0 101 0xe0 102 0xf0
  }
  array set hexLowMap {
    48 0x00 49 0x01 50 0x02 51 0x03 52 0x04  53 0x05  54 0x06  55 0x07
    56 0x08 57 0x09 65 0x0a 66 0x0b 67 0x0c  68 0x0d  69 0x0e  70 0x0f
                    97 0x0a 98 0x0b 99 0x0c 100 0x0d 101 0x0e 102 0x0f
  }
  binary scan $hexData c* data
  set lstData {}
  foreach {hexHigh hexLow} $data {
    set highByte $hexHighMap($hexHigh)
    set lowByte $hexLowMap($hexLow)
    set datum [expr $highByte + $lowByte]
    lappend lstData $datum
  }
  return $lstData
}

# converts binary data to list data
proc bin2lst {binData} {
  set lstData {}
  set binDataLength [string length $binData]
  for {set i 0} {$i < $binDataLength} {incr i} {
    set datum [scan [string range $binData $i $i] %c]
    lappend lstData $datum
  }
  return $lstData
}

# converts list data to binary data
proc lst2bin {lstData} {
  set binData ""
  foreach {datum} $lstData {
    set binDatum [format %c $datum]
    append binData $binDatum
  }
  return $binData
}
