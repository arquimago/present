# About

This project contains a VHDL implementation of an IP Core that performs the
PRESENT encryption / decryption, as well as the drivers and sample C project
that uses the libraries.

This was written for an Embedded Hardware System Design module at the
National University of Singapore, and as of the writing of this README is also
available in a more complete form (with the project report) on the
"Sample Projects" page of the NUS Wiki at
http://wiki.nus.edu.sg/display/ee4218/Sample+Projects

# Implementation Details

The IP Cores were originally designed and tested on a Xilinx SPARTAN-3E FPGA,
but have been verified to work on anything up to a SPARTAN-6.
It should work on any FPGA that has a microprocessor (soft or hard) with an
FSL bus available. It can easily be adapted to support other interconnects
so long as the user is competent enough in HDLs, as the bus logic is mostly
decoupled from the crypto logic.

# Notice to Users

While this does implement a cryptographic algorithm, absolutely no care was
taken to ensure that it is suitable for any real life applications. It is 
known to be vulnerable to certain side-channel attacks.

# License

Copyright (c) 2012, Arunapuram Gokul Rahul and Ong Zibin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the National University of Singapore nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.