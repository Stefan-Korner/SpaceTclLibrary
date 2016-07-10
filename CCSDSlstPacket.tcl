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
# CCSDS and PUS list packet processing                                        *
#******************************************************************************
namespace eval CCSDSlstPacket {}
namespace eval CCSDSpacket {}

###################
# generic getters #
###################

proc CCSDSlstPacket::getUInt8 {lstPacket bytePos {mask 0xFF}} {
  set byte0 [lindex $lstPacket $bytePos]
  return [expr $byte0 & $mask]
}

proc CCSDSlstPacket::getUInt16 {lstPacket bytePos {mask 0xFFFF}} {
  set byte0 [lindex $lstPacket $bytePos]
  incr bytePos
  set byte1 [lindex $lstPacket $bytePos]
  return [expr (($byte0 * 0x100) + $byte1) & $mask]
}

proc CCSDSlstPacket::getUInt32 {lstPacket bytePos {mask 0xFFFFFFFF}} {
  set byte0 [lindex $lstPacket $bytePos]
  incr bytePos
  set byte1 [lindex $lstPacket $bytePos]
  incr bytePos
  set byte2 [lindex $lstPacket $bytePos]
  incr pktBytePos
  set byte3 [lindex $lstPacket $bytePos]
  return [expr (($byte0 * 0x100) + $byte1) * 0x100 + $byte2) * 0x100 + $byte3) & $mask]
}

###################
# generic setters #
###################

proc CCSDSlstPacket::setUInt8 {lstPacketName bytePos value {mask 0xFF}} {
  upvar $lstPacketName lstPacket
  if {$mask != 0xFF} {
    # read
    set packetValue [getUInt8 $lstPacket $bytePos]
    # modify
    set inverseMask [expr $mask ^ 0xFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set byte0 $value
  lset lstPacket $bytePos $byte0
}

proc CCSDSlstPacket::setUInt16 {lstPacketName bytePos value {mask 0xFFFF}} {
  upvar $lstPacketName lstPacket
  if {$mask != 0xFFFF} {
    # read
    set packetValue [getUInt16 $lstPacket $bytePos]
    # modify
    set inverseMask [expr $mask ^ 0xFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set byte0 [expr ($value & 0xFF00) / 0x100]
  set byte1 [expr  $value & 0xFF]
  lset lstPacket $bytePos $byte0
  incr bytePos
  lset lstPacket $bytePos $byte1
}

proc CCSDSlstPacket::setUInt32 {lstPacket pktBytePos value {mask 0xFFFFFFFF}} {
  upvar $lstPacketName lstPacket
  if {$mask != 0xFFFFFFFF} {
    # read
    set packetValue [getUInt32 $lstPacket $bytePos]
    # modify
    set inverseMask [expr $mask ^ 0xFFFFFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set byte0 [expr ($value & 0xFF000000) / 0x1000000]
  set byte1 [expr ($value & 0xFF0000) / 0x10000]
  set byte2 [expr ($value & 0xFF00) / 0x100]
  set byte3 [expr  $value & 0xFF]
  lset lstPacket $bytePos $byte0
  incr bytePos
  lset lstPacket $bytePos $byte1
  incr bytePos
  lset lstPacket $bytePos $byte2
  incr bytePos
  lset lstPacket $bytePos $byte3
}

####################
# specific getters #
####################

# extracts the APID from a CCSDS packet
proc CCSDSlstPacket::getAPID {lstPacket} {
  return [CCSDSlstPacket::getUInt16 $lstPacket 0 0x07FF]
}

# extracts the SSC from a CCSDS packet
proc CCSDSlstPacket::getSSC {lstPacket} {
  return [CCSDSlstPacket::getUInt16 $lstPacket 2 0x3FFF]
}

# extracts the packet length from a CCSDS packet
proc CCSDSlstPacket::getPacketLength {lstPacket} {
  return [CCSDSlstPacket::getUInt16 $lstPacket 4]
}

# extracts the CRC from a CCSDS packet
proc CCSDSlstPacket::getCRC {lstPacket} {
  set lstPacketLength [llength $lstPacket]
  set binCrcPos [expr $lstPacketLength - 2]
  return [CCSDSlstPacket::getUInt16 $lstPacket $binCrcPos]
}

# extracts the PUS type from a PUS packet
proc CCSDSlstPacket::getPusType {lstPacket} {
  return [CCSDSlstPacket::getUInt8 $lstPacket 7]
}

# extracts the PUS sub-type from a PUS packet
proc CCSDSlstPacket::getPusSubType {lstPacket} {
  return [CCSDSlstPacket::getUInt8 $lstPacket 8]
}

####################
# specific setters #
####################

# sets the APID in a CCSDS packet
proc CCSDSlstPacket::setAPID {lstPacketName apid} {
  upvar $lstPacketName lstPacket
  CCSDSlstPacket::setUInt16 lstPacket 0 $apid 0x07FF
}

# sets the SSC in a CCSDS packet
proc CCSDSlstPacket::setSSC {lstPacketName ssc} {
  upvar $lstPacketName lstPacket
  CCSDSlstPacket::setUInt16 lstPacket 2 $ssc 0x3FFF
}

# sets the packet length field in a CCSDS packet
proc CCSDSlstPacket::setPacketLength {lstPacketName packetLength} {
  upvar $lstPacketName lstPacket
  CCSDSlstPacket::setUInt16 lstPacket 4 $packetLength
}

# sets the CRC in a CCSDS packet
proc CCSDSlstPacket::setCRC {lstPacketName crc} {
  upvar $lstPacketName lstPacket
  set lstPacketLength [llength $lstPacket]
  set binCrcPos [expr $lstPacketLength - 2]
  CCSDSlstPacket::setUInt16 lstPacket $binCrcPos $crc
}

# sets the PUS type in a PUS packet
proc CCSDSlstPacket::setPusType {lstPacketName pusType} {
  upvar $lstPacketName lstPacket
  CCSDSlstPacket::setUInt8 lstPacket 7 $pusType
}

# sets the PUS sub-type in a PUS packet
proc CCSDSlstPacket::setPusSubType {lstPacketName pusSubType} {
  upvar $lstPacketName lstPacket
  CCSDSlstPacket::setUInt8 lstPacket 8 $pusSubType
}

###################
# CRC calculation #
###################

# calculates the CRC from a packet
proc CCSDSlstPacket::calcCRC {lstPacket} {
  set table {
    0x0000 0x1021 0x2042 0x3063 0x4084 0x50a5 0x60c6 0x70e7
    0x8108 0x9129 0xa14a 0xb16b 0xc18c 0xd1ad 0xe1ce 0xf1ef
    0x1231 0x0210 0x3273 0x2252 0x52b5 0x4294 0x72f7 0x62d6
    0x9339 0x8318 0xb37b 0xa35a 0xd3bd 0xc39c 0xf3ff 0xe3de
    0x2462 0x3443 0x0420 0x1401 0x64e6 0x74c7 0x44a4 0x5485
    0xa56a 0xb54b 0x8528 0x9509 0xe5ee 0xf5cf 0xc5ac 0xd58d
    0x3653 0x2672 0x1611 0x0630 0x76d7 0x66f6 0x5695 0x46b4
    0xb75b 0xa77a 0x9719 0x8738 0xf7df 0xe7fe 0xd79d 0xc7bc
    0x48c4 0x58e5 0x6886 0x78a7 0x0840 0x1861 0x2802 0x3823
    0xc9cc 0xd9ed 0xe98e 0xf9af 0x8948 0x9969 0xa90a 0xb92b
    0x5af5 0x4ad4 0x7ab7 0x6a96 0x1a71 0x0a50 0x3a33 0x2a12
    0xdbfd 0xcbdc 0xfbbf 0xeb9e 0x9b79 0x8b58 0xbb3b 0xab1a
    0x6ca6 0x7c87 0x4ce4 0x5cc5 0x2c22 0x3c03 0x0c60 0x1c41
    0xedae 0xfd8f 0xcdec 0xddcd 0xad2a 0xbd0b 0x8d68 0x9d49
    0x7e97 0x6eb6 0x5ed5 0x4ef4 0x3e13 0x2e32 0x1e51 0x0e70
    0xff9f 0xefbe 0xdfdd 0xcffc 0xbf1b 0xaf3a 0x9f59 0x8f78
    0x9188 0x81a9 0xb1ca 0xa1eb 0xd10c 0xc12d 0xf14e 0xe16f
    0x1080 0x00a1 0x30c2 0x20e3 0x5004 0x4025 0x7046 0x6067
    0x83b9 0x9398 0xa3fb 0xb3da 0xc33d 0xd31c 0xe37f 0xf35e
    0x02b1 0x1290 0x22f3 0x32d2 0x4235 0x5214 0x6277 0x7256
    0xb5ea 0xa5cb 0x95a8 0x8589 0xf56e 0xe54f 0xd52c 0xc50d
    0x34e2 0x24c3 0x14a0 0x0481 0x7466 0x6447 0x5424 0x4405
    0xa7db 0xb7fa 0x8799 0x97b8 0xe75f 0xf77e 0xc71d 0xd73c
    0x26d3 0x36f2 0x0691 0x16b0 0x6657 0x7676 0x4615 0x5634
    0xd94c 0xc96d 0xf90e 0xe92f 0x99c8 0x89e9 0xb98a 0xa9ab
    0x5844 0x4865 0x7806 0x6827 0x18c0 0x08e1 0x3882 0x28a3
    0xcb7d 0xdb5c 0xeb3f 0xfb1e 0x8bf9 0x9bd8 0xabbb 0xbb9a
    0x4a75 0x5a54 0x6a37 0x7a16 0x0af1 0x1ad0 0x2ab3 0x3a92
    0xfd2e 0xed0f 0xdd6c 0xcd4d 0xbdaa 0xad8b 0x9de8 0x8dc9
    0x7c26 0x6c07 0x5c64 0x4c45 0x3ca2 0x2c83 0x1ce0 0x0cc1
    0xef1f 0xff3e 0xcf5d 0xdf7c 0xaf9b 0xbfba 0x8fd9 0x9ff8
    0x6e17 0x7e36 0x4e55 0x5e74 0x2e93 0x3eb2 0x0ed1 0x1ef0
  }
  set crc 0xffff
  foreach {datum} $lstPacket {
    set crc [expr {[lindex $table [expr {(($crc >> 8) ^ $datum) & 0xff}]] ^ ($crc << 8) & 0xffff}]
  }
  return $crc
}

#####################
# packet processing #
#####################

# efficient creation of a packet
proc CCSDSlstPacket::createTmPkt {apid pusType pusSubType lstData \
  {calcTime true} \
  {appendCrc true} \
  {pusHeaderByteSize 12} \
  {timeByteOffset 10} \
  {fineTimeByteSize 4}} \
{
  # APID
  set hdr0001 [expr $apid | 0x0800]
  set hdr00 [expr ($hdr0001 & 0xFF00) / 0x100]
  set hdr01 [expr  $hdr0001 & 0xFF]
  # SSC
  set ssc [CCSDSpacket::getNextSSC $apid]
  set hdr0203 [expr $ssc | 0xC000]
  set hdr02 [expr ($hdr0203 & 0xFF00) / 0x100]
  set hdr03 [expr  $hdr0203 & 0xFF]
  # packet length
  set allHeadersLength [expr 6 + $pusHeaderByteSize]
  set dataLength [llength $lstData]
  set packetLength [expr $allHeadersLength + $dataLength]
  if {$appendCrc} {
    incr packetLength 2
  }
  set packetLengthValue [expr $packetLength - 7]
  set hdr0405 $packetLengthValue
  set hdr04 [expr ($hdr0405 & 0xFF00) / 0x100]
  set hdr05 [expr  $hdr0405 & 0xFF]
  # PUS version
  set hdr06 0x10
  # PUS type
  set hdr07 $pusType
  # PUS sub-type
  set hdr08 $pusSubType
  # filler 1 and time stamp
  set fillerStartBytePos 9
  if {$calcTime} {
    # filler 1
    set fillerLength [expr $timeByteOffset - $fillerStartBytePos]
    if {$fillerLength >= 1} {
      set hdrFill1 [lrepeat $fillerLength 0]
    } else {
      set hdrFill1 {}
    }
    incr fillerStartBytePos $fillerLength
    # coarse time
    set hdrCoarse {0 0 0 0}
    incr fillerStartBytePos 4
    # fine time
    if {$fineTimeByteSize >= 1} {
      set hdrFine [lrepeat $fineTimeByteSize 0]
    } else {
      set hdrFine {}
    }
    incr fillerStartBytePos $fineTimeByteSize
  } else {
    set hdrFill1 {}
    set hdrCoarse {}
    set hdrFine {}
  }
  # filler 2
  set fillerLength [expr $allHeadersLength - $fillerStartBytePos]
  if {$fillerLength >= 1} {
    set hdrFill2 [lrepeat $fillerLength 0]
  } else {
    set hdrFill2 {}
  }
  # packet without CRC
  set hdr00_08 {}
  lappend hdr00_08 $hdr00 $hdr01 $hdr02 $hdr03 $hdr04 $hdr05 $hdr06 $hdr07 $hdr08
  set lstPacket [concat $hdr00_08 $hdrFill1 $hdrCoarse $hdrFine $hdrFill2 $lstData]
  # CRC
  if {$appendCrc} {
    set crc [CCSDSlstPacket::calcCRC $lstPacket]
    set crc00 [expr ($crc & 0xFF00) / 0x100]
    set crc01 [expr  $crc & 0xFF]
    lappend lstPacket $crc00
    lappend lstPacket $crc01
  }
  return $lstPacket
}

# updates the packet with the next SSC
proc CCSDSlstPacket::update {lstPacketName calcCRC} {
  upvar $lstPacketName lstPacket
  # update SSC
  set apid [CCSDSlstPacket::getAPID $lstPacket]
  set ssc [CCSDSpacket::getNextSSC $apid]
  CCSDSlstPacket::setSSC lstPacket $ssc
  # update packet length
  set lstPacketLength [llength $lstPacket]
  set packetLengthValue [expr $lstPacketLength - 7]
  CCSDSbinPacket::setPacketLength lstPacket $packetLengthValue
  # update CRC
  if {$calcCRC} {
    set lstCrcPrevPos [expr $lstPacketLength - 3]
    set lstPacketWithoutCRC [lrange $lstPacket 0 $lstCrcPrevPos]
    set crc [CCSDSlstPacket::calcCRC $lstPacketWithoutCRC]
    CCSDSlstPacket::setCRC lstPacket $crc
  }
}
