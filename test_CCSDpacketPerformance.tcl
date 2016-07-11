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
# performance tests for different CCSDS packet types (bin, hex, lst)          *
#******************************************************************************
lappend auto_path $env(PWD)   # load procedures defined in tclIndex
namespace eval CCSDSbinPacket {}
namespace eval CCSDShexPacket {}
namespace eval CCSDSlstPacket {}
namespace eval CCSDSpacket {}

set counter0 0
set counter1 0

proc testCCSDSbinPacket {} {
  LOG "test CCSDSbinPacket..."
  set binPacket ""
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  append binPacket "0123456789abcdef"
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [CCSDSbinPacket::getUInt8 $binPacket $i]
      if {$nextByte <= 57} {
        incr ::counter0
      } else {
        incr ::counter1
      }
    }
  }
  set stopTime [clock seconds]
  set deltaTime1 [expr $stopTime - $startTime]
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [expr $i + 48]
      set binPacket [CCSDSbinPacket::setUInt8 $binPacket $i $nextByte]
    }
  }
  set stopTime [clock seconds]
  set deltaTime2 [expr $stopTime - $startTime]
  set totalTime [expr $deltaTime1 + $deltaTime2]
  LOG "test CCSDSbinPacket read  = $deltaTime1 seconds"
  LOG "test CCSDSbinPacket write = $deltaTime2 seconds"
  LOG "test CCSDSbinPacket total = $totalTime seconds"
  LOG "binPacket = $binPacket"
  LOG ""

}

proc testCCSDShexPacket {} {
  LOG "test CCSDShexPacket..."
  set hexPacket ""
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  append hexPacket "30313233343536373839616263646566"
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [CCSDShexPacket::getUInt8 $hexPacket $i]
      if {$nextByte <= 57} {
        incr ::counter0
      } else {
        incr ::counter1
      }
    }
  }
  set stopTime [clock seconds]
  set deltaTime1 [expr $stopTime - $startTime]
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [expr $i + 48]
      set hexPacket [CCSDShexPacket::setUInt8 $hexPacket $i $nextByte]
    }
  }
  set stopTime [clock seconds]
  set deltaTime2 [expr $stopTime - $startTime]
  set totalTime [expr $deltaTime1 + $deltaTime2]
  LOG "test CCSDShexPacket read  = $deltaTime1 seconds"
  LOG "test CCSDShexPacket write = $deltaTime2 seconds"
  LOG "test CCSDShexPacket total = $totalTime seconds"
  LOG "hexPacket = [hex2bin $hexPacket]"
  LOG ""
}

proc testCCSDSlstPacket {} {
  LOG "test CCSDSlstPacket..."
  set lstPacket {}
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  lappend lstPacket 48 49 50 51 52 53 54 55 54 57 97 98 99 100 101 102
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [CCSDSlstPacket::getUInt8 $lstPacket $i]
      if {$nextByte <= 57} {
        incr ::counter0
      } else {
        incr ::counter1
      }
    }
  }
  set stopTime [clock seconds]
  set deltaTime1 [expr $stopTime - $startTime]
  set startTime [clock seconds]
  for {set j 0} {$j < 100000} {incr j} {
    for {set i 0} {$i < 16} {incr i} {
      set nextByte [expr $i + 48]
      CCSDSlstPacket::setUInt8 lstPacket $i $nextByte
    }
  }
  set stopTime [clock seconds]
  set deltaTime2 [expr $stopTime - $startTime]
  set totalTime [expr $deltaTime1 + $deltaTime2]
  LOG "test CCSDSlstPacket read  = $deltaTime1 seconds"
  LOG "test CCSDSlstPacket write = $deltaTime2 seconds"
  LOG "test CCSDSlstPacket total = $totalTime seconds"
  LOG "lstPacket = [lst2bin $lstPacket]"
  LOG ""
}

testCCSDSbinPacket
testCCSDShexPacket
testCCSDSlstPacket
LOG "tests done"
puts "counter0 = $counter0"
puts "counter1 = $counter1"
