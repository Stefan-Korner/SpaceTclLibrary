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
# CCSDS and PUS hex packet processing                                         *
#******************************************************************************
namespace eval CCSDSbinPacket {}
namespace eval CCSDShexPacket {}
namespace eval CCSDSpacket {}

###################
# generic getters #
###################

# note: pktBytePos is the byte position of the value in the *binary* packet
proc CCSDShexPacket::getUInt8 {hexPacket pktBytePos {mask 0xFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 1]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

proc CCSDShexPacket::getUInt16 {hexPacket pktBytePos {mask 0xFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 3]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

proc CCSDShexPacket::getUInt32 {hexPacket pktBytePos {mask 0xFFFFFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 7]
  set hexValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
  scan $hexValue %x value
  return [expr $value & $mask]
}

###################
# generic setters #
###################

# note: pktBytePos is the byte position of the value in the *binary* packet
proc CCSDShexPacket::setUInt8 {hexPacket pktBytePos value {mask 0xFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 1]
  if {$mask != 0xFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %02X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

proc CCSDShexPacket::setUInt16 {hexPacket pktBytePos value {mask 0xFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 3]
  if {$mask != 0xFFFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %04X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

proc CCSDShexPacket::setUInt32 {hexPacket pktBytePos value {mask 0xFFFFFFFF}} {
  set hexStartBytePos [expr $pktBytePos * 2]
  set hexEndBytePos [expr ($pktBytePos * 2) + 7]
  if {$mask != 0xFFFFFFFF} {
    # read
    set hexPacketValue [string range $hexPacket $hexStartBytePos $hexEndBytePos]
    # modify
    scan $hexPacketValue %x packetValue
    set inverseMask [expr $mask ^ 0xFFFFFFFF]
    set packetValue [expr $packetValue & $inverseMask]
    set value [expr $value | $packetValue]
  }
  # write
  set hexValue [format %08X $value]
  return [string replace $hexPacket $hexStartBytePos $hexEndBytePos $hexValue]
}

####################
# specific getters #
####################

# extracts the APID from a CCSDS packet
proc CCSDShexPacket::getAPID {hexPacket} {
  return [CCSDShexPacket::getUInt16 $hexPacket 0 0x07FF]
}

# extracts the SSC from a CCSDS packet
proc CCSDShexPacket::getSSC {hexPacket} {
  return [CCSDShexPacket::getUInt16 $hexPacket 2 0x3FFF]
}

# extracts the packet length from a CCSDS packet
proc CCSDShexPacket::getPacketLength {hexPacket} {
  return [CCSDShexPacket::getUInt16 $hexPacket 4]
}

# extracts the CRC from a CCSDS packet
proc CCSDShexPacket::getCRC {hexPacket} {
  set hexPacketLength [string length $hexPacket]
  set binCrcPos [expr ($hexPacketLength / 2) - 2]
  return [CCSDShexPacket::getUInt16 $hexPacket $binCrcPos]
}

# extracts the PUS type from a PUS packet
proc CCSDShexPacket::getPusType {hexPacket} {
  return [CCSDShexPacket::getUInt8 $hexPacket 7]
}

# extracts the PUS sub-type from a PUS packet
proc CCSDShexPacket::getPusSubType {hexPacket} {
  return [CCSDShexPacket::getUInt8 $hexPacket 8]
}

####################
# specific setters #
####################

# sets the APID in a CCSDS packet
proc CCSDShexPacket::setAPID {hexPacket apid} {
  return [CCSDShexPacket::setUInt16 $hexPacket 0 $apid 0x07FF]
}

# sets the SSC in a CCSDS packet
proc CCSDShexPacket::setSSC {hexPacket ssc} {
  return [CCSDShexPacket::setUInt16 $hexPacket 2 $ssc 0x3FFF]
}

# sets the packet length field in a CCSDS packet
proc CCSDShexPacket::setPacketLength {hexPacket packetLength} {
  return [CCSDShexPacket::setUInt16 $hexPacket 4 $packetLength]
}

# sets the CRC in a CCSDS packet
proc CCSDShexPacket::setCRC {hexPacket crc} {
  set hexPacketLength [string length $hexPacket]
  set binCrcPos [expr ($hexPacketLength / 2) - 2]
  return [CCSDShexPacket::setUInt16 $hexPacket $binCrcPos $crc]
}

# sets the PUS type in a PUS packet
proc CCSDShexPacket::setPusType {hexPacket pusType} {
  return [CCSDShexPacket::setUInt8 $hexPacket 7 $pusType]
}

# sets the PUS sub-type in a PUS packet
proc CCSDShexPacket::setPusSubType {hexPacket pusSubType} {
  return [CCSDShexPacket::setUInt8 $hexPacket 8 $pusSubType]
}

#####################
# packet processing #
#####################

# efficient creation of a packet
proc CCSDShexPacket::createTmPkt {apid pusType pusSubType hexData \
  {calcTime true} \
  {appendCrc true} \
  {pusHeaderByteSize 12} \
  {timeByteOffset 10} \
  {fineTimeByteSize 4}} \
{
  # APID
  set hdr0001 [expr $apid | 0x0800]
  set hdrx0001 [format %04X $hdr0001]
  # SSC
  set ssc [CCSDSpacket::getNextSSC $apid]
  set hdr0203 [expr $ssc | 0xC000]
  set hdrx0203 [format %04X $hdr0203]
  # packet length
  set allHeadersLength [expr 6 + $pusHeaderByteSize]
  set hexDataLength [string length $hexData]
  set dataLength [expr $hexDataLength / 2]
  set packetLength [expr $allHeadersLength + $dataLength]
  if {$appendCrc} {
    incr packetLength 2
  }
  set packetLengthValue [expr $packetLength - 7]
  set hdr0405 $packetLengthValue
  set hdrx0405 [format %04X $hdr0405]
  # PUS version
  set hdr06 0x10
  set hdrx06 [format %02X $hdr06]
  # PUS type
  set hdr07 $pusType
  set hdrx07 [format %02X $hdr07]
  # PUS sub-type
  set hdr08 $pusSubType
  set hdrx08 [format %02X $hdr08]
  # filler 1 and time stamp
  set fillerStartBytePos 9
  if {$calcTime} {
    # filler 1
    set fillerLength [expr $timeByteOffset - $fillerStartBytePos]
    set hdrxFill1 [string repeat "00" $fillerLength]
    incr fillerStartBytePos $fillerLength
    # coarse time
    set hdrxCoarse "00000000"
    incr fillerStartBytePos 4
    # fine time
    set hdrxFine [string repeat "00" $fineTimeByteSize]
    incr fillerStartBytePos $fineTimeByteSize
  } else {
    set hdrxFill1 ""
    set hdrxCoarse ""
    set hdrxFine ""
  }
  # filler 2
  set fillerLength [expr $allHeadersLength - $fillerStartBytePos]
  set hdrxFill2 [string repeat "00" $fillerLength]
  # packet without CRC
  set hexPacket ${hdrx0001}${hdrx0203}${hdrx0405}${hdrx06}${hdrx07}${hdrx08}${hdrxFill1}${hdrxCoarse}${hdrxFine}${hdrxFill2}${hexData}
  # CRC
  if {$appendCrc} {
    set binPacket [binary format H* $hexPacket]
    set crc [CCSDSbinPacket::calcCRC $binPacket]
    set hexCRC [format %04X $crc]
    set hexPacket ${hexPacket}${hexCRC}
  }
  return $hexPacket
}

# updates the packet with the next SSC
proc CCSDShexPacket::update {hexPacket calcCRC} {
  # update SSC
  set apid [CCSDShexPacket::getAPID $hexPacket]
  set ssc [CCSDSpacket::getNextSSC $apid]
  set hexPacket [CCSDShexPacket::setSSC $hexPacket $ssc]
  # update packet length
  set hexPacketLength [string length $hexPacket]
  set packetLengthValue [expr ($hexPacketLength / 2) - 7]
  set hexPacket [CCSDShexPacket::setPacketLength $hexPacket $packetLengthValue]
  # update CRC
  if {$calcCRC} {
    set hexCrcPrevPos [expr $hexPacketLength - 5]
    set hexPacketWithoutCRC [string range $hexPacket 0 $hexCrcPrevPos]
    set binPacketWithoutCRC [binary format H* $hexPacketWithoutCRC]
    set crc [CCSDSbinPacket::calcCRC $binPacketWithoutCRC]
    set hexCRC [format %04X $crc]
    set hexPacket ${hexPacketWithoutCRC}${hexCRC}
  }
  return $hexPacket
}
