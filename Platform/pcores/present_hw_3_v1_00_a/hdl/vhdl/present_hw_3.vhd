------------------------------------------------------------------------------
-- present_hw_3 - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          present_hw_3
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Tue Apr 03 15:04:46 2012 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package present_func is
  subtype nibble is std_logic_vector(3 downto 0);
  function sbox(input : nibble) return nibble;
  function inv_sbox(input : nibble) return nibble;
end present_func ;

package body present_func is
  function sbox(input : nibble) return nibble is
  begin
    case(input) is
      when x"0" => return x"C";
      when x"1" => return x"5";
      when x"2" => return x"6";
      when x"3" => return x"B";
      when x"4" => return x"9";
      when x"5" => return x"0";
      when x"6" => return x"A";
      when x"7" => return x"D";
      when x"8" => return x"3";
      when x"9" => return x"E";
      when x"A" => return x"F";
      when x"B" => return x"8";
      when x"C" => return x"4";
      when x"D" => return x"7";
      when x"E" => return x"1";
      when x"F" => return x"2";
      when others => return "ZZZZ";
    end case ;
  end sbox;

  function inv_sbox(input : nibble) return nibble is
  begin
    case(input) is
      when x"C" => return x"0";
      when x"5" => return x"1";
      when x"6" => return x"2";
      when x"B" => return x"3";
      when x"9" => return x"4";
      when x"0" => return x"5";
      when x"A" => return x"6";
      when x"D" => return x"7";
      when x"3" => return x"8";
      when x"E" => return x"9";
      when x"F" => return x"A";
      when x"8" => return x"B";
      when x"4" => return x"C";
      when x"7" => return x"D";
      when x"1" => return x"E";
      when x"2" => return x"F";
      when others => return "ZZZZ";
    end case ;
  end inv_sbox;
end present_func ;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

entity keygen_upd is
  port (
    input : in std_logic_vector(79 downto 0);
    round_value : in std_logic_vector(5 downto 0);
    output : out std_logic_vector(79 downto 0)
  );
end keygen_upd;

architecture keygen_upd_arch of keygen_upd is
begin
   output(79 downto 76) <= sbox(input(79 downto 76)); 
   output(75 downto 20) <= input(75 downto 20);
   output(19 downto 15) <= input(19 downto 15) xor round_value(4 downto 0);
   output(14 downto 0) <= input(14 downto 0);
end architecture ; -- keygen_upd_arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

entity pd_player is
  port (
    input : in std_logic_vector(63 downto 0);
    output : out std_logic_vector(63 downto 0)
  );
end pd_player;

architecture pd_player_arch of pd_player is
begin
  output(0) <= input(0);
  output(1) <= input(16);
  output(2) <= input(32);
  output(3) <= input(48);
  output(4) <= input(1);
  output(5) <= input(17);
  output(6) <= input(33);
  output(7) <= input(49);
  output(8) <= input(2);
  output(9) <= input(18);
  output(10) <= input(34);
  output(11) <= input(50);
  output(12) <= input(3);
  output(13) <= input(19);
  output(14) <= input(35);
  output(15) <= input(51);
  output(16) <= input(4);
  output(17) <= input(20);
  output(18) <= input(36);
  output(19) <= input(52);
  output(20) <= input(5);
  output(21) <= input(21);
  output(22) <= input(37);
  output(23) <= input(53);
  output(24) <= input(6);
  output(25) <= input(22);
  output(26) <= input(38);
  output(27) <= input(54);
  output(28) <= input(7);
  output(29) <= input(23);
  output(30) <= input(39);
  output(31) <= input(55);
  output(32) <= input(8);
  output(33) <= input(24);
  output(34) <= input(40);
  output(35) <= input(56);
  output(36) <= input(9);
  output(37) <= input(25);
  output(38) <= input(41);
  output(39) <= input(57);
  output(40) <= input(10);
  output(41) <= input(26);
  output(42) <= input(42);
  output(43) <= input(58);
  output(44) <= input(11);
  output(45) <= input(27);
  output(46) <= input(43);
  output(47) <= input(59);
  output(48) <= input(12);
  output(49) <= input(28);
  output(50) <= input(44);
  output(51) <= input(60);
  output(52) <= input(13);
  output(53) <= input(29);
  output(54) <= input(45);
  output(55) <= input(61);
  output(56) <= input(14);
  output(57) <= input(30);
  output(58) <= input(46);
  output(59) <= input(62);
  output(60) <= input(15);
  output(61) <= input(31);
  output(62) <= input(47);
  output(63) <= input(63);
end architecture ; -- pd_player_arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

entity pd_sbox is
  port (
    input : in std_logic_vector(63 downto 0);
    output : out std_logic_vector(63 downto 0)
  );
end pd_sbox;

architecture pd_sbox_arch of pd_sbox is
begin
  output(63 downto 60) <= inv_sbox(input(63 downto 60));
  output(59 downto 56) <= inv_sbox(input(59 downto 56));
  output(55 downto 52) <= inv_sbox(input(55 downto 52));
  output(51 downto 48) <= inv_sbox(input(51 downto 48));
  output(47 downto 44) <= inv_sbox(input(47 downto 44));
  output(43 downto 40) <= inv_sbox(input(43 downto 40));
  output(39 downto 36) <= inv_sbox(input(39 downto 36));
  output(35 downto 32) <= inv_sbox(input(35 downto 32));
  output(31 downto 28) <= inv_sbox(input(31 downto 28));
  output(27 downto 24) <= inv_sbox(input(27 downto 24));
  output(23 downto 20) <= inv_sbox(input(23 downto 20));
  output(19 downto 16) <= inv_sbox(input(19 downto 16));
  output(15 downto 12) <= inv_sbox(input(15 downto 12));
  output(11 downto  8) <= inv_sbox(input(11 downto  8));
  output( 7 downto  4) <= inv_sbox(input( 7 downto  4));
  output( 3 downto  0) <= inv_sbox(input( 3 downto  0));
end architecture ; -- pd_sbox_arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

entity pe_player is
  port (
    input : in std_logic_vector(63 downto 0);
    output : out std_logic_vector(63 downto 0)
  );
end pe_player;

architecture pe_player_arch of pe_player is
begin
  output(0)  <= input(0);
  output(16) <= input(1);
  output(32) <= input(2);
  output(48) <= input(3);
  output(1)  <= input(4);
  output(17) <= input(5);
  output(33) <= input(6);
  output(49) <= input(7);
  output(2)  <= input(8);
  output(18) <= input(9);
  output(34) <= input(10);
  output(50) <= input(11);
  output(3)  <= input(12);
  output(19) <= input(13);
  output(35) <= input(14);
  output(51) <= input(15);
  output(4)  <= input(16);
  output(20) <= input(17);
  output(36) <= input(18);
  output(52) <= input(19);
  output(5)  <= input(20);
  output(21) <= input(21);
  output(37) <= input(22);
  output(53) <= input(23);
  output(6)  <= input(24);
  output(22) <= input(25);
  output(38) <= input(26);
  output(54) <= input(27);
  output(7)  <= input(28);
  output(23) <= input(29);
  output(39) <= input(30);
  output(55) <= input(31);
  output(8)  <= input(32);
  output(24) <= input(33);
  output(40) <= input(34);
  output(56) <= input(35);
  output(9)  <= input(36);
  output(25) <= input(37);
  output(41) <= input(38);
  output(57) <= input(39);
  output(10) <= input(40);
  output(26) <= input(41);
  output(42) <= input(42);
  output(58) <= input(43);
  output(11) <= input(44);
  output(27) <= input(45);
  output(43) <= input(46);
  output(59) <= input(47);
  output(12) <= input(48);
  output(28) <= input(49);
  output(44) <= input(50);
  output(60) <= input(51);
  output(13) <= input(52);
  output(29) <= input(53);
  output(45) <= input(54);
  output(61) <= input(55);
  output(14) <= input(56);
  output(30) <= input(57);
  output(46) <= input(58);
  output(62) <= input(59);
  output(15) <= input(60);
  output(31) <= input(61);
  output(47) <= input(62);
  output(63) <= input(63);
end architecture ; -- pe_player_arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

entity pe_sbox is
  port (
    input : in std_logic_vector(63 downto 0);
    output : out std_logic_vector(63 downto 0)
  );
end pe_sbox;

architecture pe_sbox_arch of pe_sbox is
begin
  output(63 downto 60) <= sbox(input(63 downto 60));
  output(59 downto 56) <= sbox(input(59 downto 56));
  output(55 downto 52) <= sbox(input(55 downto 52));
  output(51 downto 48) <= sbox(input(51 downto 48));
  output(47 downto 44) <= sbox(input(47 downto 44));
  output(43 downto 40) <= sbox(input(43 downto 40));
  output(39 downto 36) <= sbox(input(39 downto 36));
  output(35 downto 32) <= sbox(input(35 downto 32));
  output(31 downto 28) <= sbox(input(31 downto 28));
  output(27 downto 24) <= sbox(input(27 downto 24));
  output(23 downto 20) <= sbox(input(23 downto 20));
  output(19 downto 16) <= sbox(input(19 downto 16));
  output(15 downto 12) <= sbox(input(15 downto 12));
  output(11 downto  8) <= sbox(input(11 downto  8));
  output( 7 downto  4) <= sbox(input( 7 downto  4));
  output( 3 downto  0) <= sbox(input( 3 downto  0));
end architecture ; -- pe_sbox_arch

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.present_func.all;

-------------------------------------------------------------------------------------
--
--
-- Definition of Ports
-- FSL_Clk             : Synchronous clock
-- FSL_Rst           : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Section
------------------------------------------------------------------------------

entity present_hw_3 is
  port 
  (
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add or delete. 
    FSL_Clk : in  std_logic;
    FSL_Rst : in  std_logic;
    FSL_S_Clk : in  std_logic;
    FSL_S_Read  : out std_logic;
    FSL_S_Data  : in  std_logic_vector(0 to 31);
    FSL_S_Control : in  std_logic;
    FSL_S_Exists  : in  std_logic;
    FSL_M_Clk : in  std_logic;
    FSL_M_Write : out std_logic;
    FSL_M_Data  : out std_logic_vector(0 to 31);
    FSL_M_Control : out std_logic;
    FSL_M_Full  : in  std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
attribute SIGIS of FSL_M_Clk : signal is "Clk"; 

end present_hw_3;

------------------------------------------------------------------------------
-- Architecture Section
------------------------------------------------------------------------------

-- In this section, we povide an example implementation of ENTITY present_hw_3
-- that does the following:
--
-- 1. Read all inputs
-- 2. Add each input to the contents of register 'sum' which
--    acts as an accumulator
-- 3. After all the inputs have been read, write out the
--    content of 'sum' into the output FSL bus NUMBER_OF_OUTPUT_WORDS times
--
-- You will need to modify this example or implement a new architecture for
-- ENTITY present_hw_3 to implement your coprocessor

architecture EXAMPLE of present_hw_3 is

   -- Total number of input data.
   constant NUMBER_OF_INPUT_WORDS  : natural := 5;

   -- Total number of output data
   constant NUMBER_OF_OUTPUT_WORDS : natural := 2;

   type STATE_TYPE is (Idle, Read_Inputs, Processing, Write_Outputs);
   type ROUNDKEY_TYPE is array(1 to 32) of std_logic_vector(63 downto 0);
   type ROUNDKEY8_TYPE is array(1 to 8) of std_logic_vector(63 downto 0);
   type KEY_TYPE is array(1 to 32) of std_logic_vector(79 downto 0);
   type SIGNAL_STATE_TYPE is array(1 to 9) of std_logic_vector(63 downto 0);
   type ITOV_TYPE is array(1 to 32) of std_logic_vector(5 downto 0);

   signal state        : STATE_TYPE;

   -- PRESENT Signals
   signal signal_in   : std_logic_vector(63 downto 0);
   signal signal_buf    : std_logic_vector(63 downto 0);
   signal signal_out   : std_logic_vector(63 downto 0) := (others => '0');
   signal encr_buf   : std_logic_vector(63 downto 0);
   signal decr_buf   : std_logic_vector(63 downto 0);

   signal buf_key_1    : std_logic_vector(79 downto 0);
   signal buf_key_2    : std_logic_vector(79 downto 0);

   signal signal_encr  : SIGNAL_STATE_TYPE;
   signal signal_decr  : SIGNAL_STATE_TYPE;
   signal encr_sboxed  : SIGNAL_STATE_TYPE;
   signal encr_playered: SIGNAL_STATE_TYPE;
   signal decr_sboxed  : SIGNAL_STATE_TYPE;
   signal decr_playered: SIGNAL_STATE_TYPE;

   signal keytemp      : KEY_TYPE;
   signal key_rol      : KEY_TYPE;

   signal round_key    : ROUNDKEY_TYPE;
   signal round_key8   : ROUNDKEY8_TYPE;

   signal mode_encr    : std_logic := 'Z';

   signal itov         : ITOV_TYPE;

   -- Counters to store the number inputs read & outputs written
   signal nr_of_reads  : natural range 0 to NUMBER_OF_INPUT_WORDS - 1;
   signal nr_of_writes : natural range 0 to NUMBER_OF_OUTPUT_WORDS - 1;

  component pd_player
    port (
      input : in std_logic_vector(63 downto 0);
      output : out std_logic_vector(63 downto 0)
    );
  end component;

  component pd_sbox
    port (
      input : in std_logic_vector(63 downto 0);
      output : out std_logic_vector(63 downto 0)
    );
  end component;

  component pe_player
    port (
      input : in std_logic_vector(63 downto 0);
      output : out std_logic_vector(63 downto 0)
    );
  end component;

  component pe_sbox
    port (
      input : in std_logic_vector(63 downto 0);
      output : out std_logic_vector(63 downto 0)
    );
  end component;

  component keygen_upd
    port (
      input : in std_logic_vector(79 downto 0);
      round_value : in std_logic_vector(5 downto 0);
      output : out std_logic_vector(79 downto 0)
    );
  end component;

begin
   -- CAUTION:
   -- The sequence in which data are read in and written out should be
   -- consistent with the sequence they are written and read in the
   -- driver's present_hw_3.c file

   -- INIT Int to Vector table
   itov( 1) <= "000001";
   itov( 2) <= "000010";
   itov( 3) <= "000011";
   itov( 4) <= "000100";
   itov( 5) <= "000101";
   itov( 6) <= "000110";
   itov( 7) <= "000111";
   itov( 8) <= "001000";
   itov( 9) <= "001001";
   itov(10) <= "001010";
   itov(11) <= "001011";
   itov(12) <= "001100";
   itov(13) <= "001101";
   itov(14) <= "001110";
   itov(15) <= "001111";
   itov(16) <= "010000";
   itov(17) <= "010001";
   itov(18) <= "010010";
   itov(19) <= "010011";
   itov(20) <= "010100";
   itov(21) <= "010101";
   itov(22) <= "010110";
   itov(23) <= "010111";
   itov(24) <= "011000";
   itov(25) <= "011001";
   itov(26) <= "011010";
   itov(27) <= "011011";
   itov(28) <= "011100";
   itov(29) <= "011101";
   itov(30) <= "011110";
   itov(31) <= "011111";
   itov(32) <= "100000";
   -- END INIT Int to Vector table

    -- Concurrent Keygen BEGIN
   GEN_KR1 : for I in 2 to 16 generate
    key_rol(I) <= std_logic_vector(unsigned(keytemp(I-1)) rol 61);
    KUPD1 : keygen_upd port map (key_rol(I), itov(I-1), keytemp(I));
   end generate ; -- GEN_KR1

   key_rol(17) <= std_logic_vector(unsigned(keytemp(16)) rol 61);
   KBUF1 : keygen_upd port map (key_rol(17), itov(16), buf_key_1);

   GEN_KR2 : for I in 18 to 24 generate
    key_rol(I) <= std_logic_vector(unsigned(keytemp(I-1)) rol 61);
    KUPD2 : keygen_upd port map (key_rol(I), itov(I-1), keytemp(I));
   end generate ; -- GEN_KR2

   key_rol(25) <= std_logic_vector(unsigned(keytemp(24)) rol 61);
   KBUF2 : keygen_upd port map (key_rol(25), itov(24), buf_key_2);

   GEN_KR3 : for I in 26 to 32 generate -- THIS
    key_rol(I) <= std_logic_vector(unsigned(keytemp(I-1)) rol 61);
    KUPD3 : keygen_upd port map (key_rol(I), itov(I-1), keytemp(I));
   end generate ; -- GEN_KR3

   RK_STORE : for I in 1 to 32 generate  -- THIS
     round_key(I) <= keytemp(I)(79 downto 16);
   end generate RK_STORE;
   -- Concurrent Keygen END

   -- Concurrent Encrypt BEGIN
   signal_encr(1) <= signal_buf;

   GEN_ENCR : for I in 1 to 4 generate
     SBE : pe_sbox port map (signal_encr(I), encr_sboxed(I));
     PLE : pe_player port map (encr_sboxed(I), encr_playered(I));
     signal_encr(I+1) <= encr_playered(I) xor round_key8(I);
   end generate GEN_ENCR;

   SBE1 : pe_sbox port map (encr_buf, encr_sboxed(5));
   PLE1 : pe_player port map (encr_sboxed(5), encr_playered(5));
   signal_encr(6) <= encr_playered(5) xor round_key8(5);

   GEN_ENCR2 : for I in 6 to 8 generate
     SBE : pe_sbox port map (signal_encr(I), encr_sboxed(I));
     PLE : pe_player port map (encr_sboxed(I), encr_playered(I));
     signal_encr(I+1) <= encr_playered(I) xor round_key8(I);
   end generate GEN_ENCR2;
   -- Concurrent Encrypt END

   -- Concurrent Decrypt BEGIN
  signal_decr(1) <= signal_buf;
  
   GEN_DECR : for I in 1 to 4 generate
     PLD : pd_player port map (signal_decr(I), decr_playered(I));
     SBD : pd_sbox port map (decr_playered(I), decr_sboxed(I));
     signal_decr(I+1) <= decr_sboxed(I) xor round_key8(I);
   end generate GEN_DECR;

   PLD1 : pd_player port map (decr_buf, decr_playered(5));
   SBD1 : pd_sbox port map (decr_playered(5), decr_sboxed(5));
   signal_decr(6) <= decr_sboxed(5) xor round_key8(5);

   GEN_DECR2 : for I in 6 to 8 generate
     PLD : pd_player port map (signal_decr(I), decr_playered(I));
     SBD : pd_sbox port map (decr_playered(I), decr_sboxed(I));
     signal_decr(I+1) <= decr_sboxed(I) xor round_key8(I);
   end generate GEN_DECR2;
   -- Concurrent Decrypt END

   FSL_S_Read  <= FSL_S_Exists   when state = Read_Inputs   else '0';
   FSL_M_Write <= not FSL_M_Full when state = Write_Outputs else '0';

   FSL_M_Data <= signal_out(63 downto 32) when nr_of_writes = 1 else
                 signal_out(31 downto  0) when nr_of_writes = 0 else
                 (others => '0');

   The_SW_accelerator : process (FSL_Clk) is
    variable oh_no : natural range 1 to 11;
   begin  -- process The_SW_accelerator
    if FSL_Clk'event and FSL_Clk = '1' then     -- Rising clock edge
      if FSL_Rst = '1' then               -- Synchronous reset (active high)
        -- CAUTION: make sure your reset polarity is consistent with the
        -- system reset polarity
        state        <= Idle;
        nr_of_reads  <= 0;
        nr_of_writes <= 0;
        oh_no        := 1;
      else
        case state is
          when Idle =>
            if (FSL_S_Exists = '1') then
              state       <= Read_Inputs;
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;
              oh_no       := 1;
            end if;

          when Read_Inputs =>
            if (FSL_S_Exists = '1') then
              case nr_of_reads is
                when 4 =>
                  mode_encr                <= FSL_S_Data(0);
                  keytemp(1)(79 downto 64) <= FSL_S_Data(16 to 31);
                when 3 =>
                  keytemp(1)(63 downto 32) <= FSL_S_Data;
                when 2 =>
                  keytemp(1)(31 downto 0)  <= FSL_S_Data;
                when 1 =>
                  signal_in(63 downto 32)  <= FSL_S_Data;
                when 0 =>
                  signal_in(31 downto 0)   <= FSL_S_Data;
              end case;
              if (nr_of_reads = 0) then
                state        <= Processing;
                nr_of_writes <= NUMBER_OF_OUTPUT_WORDS - 1;
              else
                nr_of_reads <= nr_of_reads - 1;
              end if;
            end if;

          when Processing =>
            case oh_no is
              when 1 =>
                keytemp(17) <= buf_key_1;
              when 2 =>
                keytemp(25) <= buf_key_2;
              when 3 =>
                if mode_encr = '1' then
                  signal_buf <= signal_in xor round_key(1);
                  round_key8(1) <= round_key(2);
                  round_key8(2) <= round_key(3);
                  round_key8(3) <= round_key(4);
                  round_key8(4) <= round_key(5);
                  round_key8(5) <= round_key(6);
                  round_key8(6) <= round_key(7);
                  round_key8(7) <= round_key(8);
                  round_key8(8) <= round_key(9);
                else
                  signal_buf <= signal_in xor round_key(32);
                  round_key8(1) <= round_key(31);
                  round_key8(2) <= round_key(30);
                  round_key8(3) <= round_key(29);
                  round_key8(4) <= round_key(28);
                  round_key8(5) <= round_key(27);
                  round_key8(6) <= round_key(26);
                  round_key8(7) <= round_key(25);
                  round_key8(8) <= round_key(24);
                end if ;
              when 4 =>
                encr_buf <= signal_encr(5);
                decr_buf <= signal_decr(5);
              when 5 =>
                if mode_encr = '1' then
                  signal_buf <= signal_encr(9);
                  round_key8(1) <= round_key(10);
                  round_key8(2) <= round_key(11);
                  round_key8(3) <= round_key(12);
                  round_key8(4) <= round_key(13);
                  round_key8(5) <= round_key(14);
                  round_key8(6) <= round_key(15);
                  round_key8(7) <= round_key(16);
                  round_key8(8) <= round_key(17);
                else
                  signal_buf <= signal_decr(9);
                  round_key8(1) <= round_key(23);
                  round_key8(2) <= round_key(22);
                  round_key8(3) <= round_key(21);
                  round_key8(4) <= round_key(20);
                  round_key8(5) <= round_key(19);
                  round_key8(6) <= round_key(18);
                  round_key8(7) <= round_key(17);
                  round_key8(8) <= round_key(16);
                end if ;
              when 6 =>
                encr_buf <= signal_encr(5);
                decr_buf <= signal_decr(5);
              when 7 =>
                if mode_encr = '1' then
                  signal_buf <= signal_encr(9);
                  round_key8(1) <= round_key(18);
                  round_key8(2) <= round_key(19);
                  round_key8(3) <= round_key(20);
                  round_key8(4) <= round_key(21);
                  round_key8(5) <= round_key(22);
                  round_key8(6) <= round_key(23);
                  round_key8(7) <= round_key(24);
                  round_key8(8) <= round_key(25);
                else
                  signal_buf <= signal_decr(9);
                  round_key8(1) <= round_key(15);
                  round_key8(2) <= round_key(14);
                  round_key8(3) <= round_key(13);
                  round_key8(4) <= round_key(12);
                  round_key8(5) <= round_key(11);
                  round_key8(6) <= round_key(10);
                  round_key8(7) <= round_key(9);
                  round_key8(8) <= round_key(8);
                end if ;
              when 8 =>
                encr_buf <= signal_encr(5);
                decr_buf <= signal_decr(5);
              when 9 =>
                if mode_encr = '1' then
                  signal_buf <= signal_encr(9);
                  round_key8(1) <= round_key(26);
                  round_key8(2) <= round_key(27);
                  round_key8(3) <= round_key(28);
                  round_key8(4) <= round_key(29);
                  round_key8(5) <= round_key(30);
                  round_key8(6) <= round_key(31);
                  round_key8(7) <= round_key(32);
                  round_key8(8) <= (others => '0'); -- Unused
                else
                  signal_buf <= signal_decr(9);
                  round_key8(1) <= round_key(7);
                  round_key8(2) <= round_key(6);
                  round_key8(3) <= round_key(5);
                  round_key8(4) <= round_key(4);
                  round_key8(5) <= round_key(3);
                  round_key8(6) <= round_key(2);
                  round_key8(7) <= round_key(1);
                  round_key8(8) <= (others => '0'); -- Unused
                end if ;
              when 10 =>
                encr_buf <= signal_encr(5);
                decr_buf <= signal_decr(5);
              when 11 =>
                if mode_encr = '1' then
                  signal_out <= signal_encr(8);
                else
                  signal_out <= signal_decr(8);
                end if ;
                state <= Write_Outputs;
            end case;
            oh_no := oh_no + 1;

          when Write_Outputs =>
            if (nr_of_writes = 0) then
              state <= Idle;
            else
              if (FSL_M_Full = '0') then
                nr_of_writes <= nr_of_writes - 1;
              end if;
            end if;
        end case;
      end if;
    end if;
   end process The_SW_accelerator;
end architecture EXAMPLE;
