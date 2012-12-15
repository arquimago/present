------------------------------------------------------------------------------
-- present_hw_1 - entity/architecture pair
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
-- Filename:          present_hw_1
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Sat Mar 31 19:23:08 2012 (by Create and Import Peripheral Wizard)
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

entity present_hw_1 is
	port 
	(
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		FSL_Clk	: in	std_logic;
		FSL_Rst	: in	std_logic;
		FSL_S_Clk	: in	std_logic;
		FSL_S_Read	: out	std_logic;
		FSL_S_Data	: in	std_logic_vector(0 to 31);
		FSL_S_Control	: in	std_logic;
		FSL_S_Exists	: in	std_logic;
		FSL_M_Clk	: in	std_logic;
		FSL_M_Write	: out	std_logic;
		FSL_M_Data	: out	std_logic_vector(0 to 31);
		FSL_M_Control	: out	std_logic;
		FSL_M_Full	: in	std_logic;
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
    EXT_CLK     : in std_logic
	);

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
attribute SIGIS of FSL_M_Clk : signal is "Clk"; 
attribute SIGIS of EXT_CLK : signal is "Clk";

end present_hw_1;

------------------------------------------------------------------------------
-- Architecture Section
------------------------------------------------------------------------------

-- In this section, we povide an example implementation of ENTITY present_hw_1
-- that does the following:
--
-- 1. Read all inputs
-- 2. Add each input to the contents of register 'sum' which
--    acts as an accumulator
-- 3. After all the inputs have been read, write out the
--    content of 'sum' into the output FSL bus NUMBER_OF_OUTPUT_WORDS times
--
-- You will need to modify this example or implement a new architecture for
-- ENTITY present_hw_1 to implement your coprocessor

architecture EXAMPLE of present_hw_1 is

   -- Total number of input data.
   constant NUMBER_OF_INPUT_WORDS  : natural := 5;

   -- Total number of output data
   constant NUMBER_OF_OUTPUT_WORDS : natural := 2;

   type STATE_TYPE is (Idle, Read_Inputs, Processing, Write_Outputs);

   signal state        : STATE_TYPE;

   -- PRESENT types

   type ROUNDKEY_TYPE is array(1 to 32) of std_logic_vector(63 downto 0);
   type KEYGEN_STATE_TYPE is (Idle, BarrelShift, UpdateKey);
   type CRYPTO_STATE_TYPE is (Idle, Encrypt, SBoxEnc, PLEnc, Decrypt, PLDec, SBoxDec, Done);

   -- PRESENT Signals
   signal input_val     : std_logic_vector(63 downto 0);
   signal output_val    : std_logic_vector(63 downto 0);
   signal key_in        : std_logic_vector(79 downto 0);

   signal roundkey      : ROUNDKEY_TYPE;

   signal crypto_sig    : std_logic_vector(63 downto 0);
   signal crypto_sig_t  : std_logic_vector(63 downto 0);
   signal key           : std_logic_vector(79 downto 0);

   signal keygen_start  : std_logic := '0';
   signal keygen_done   : std_logic := '0';

   signal keygen_state  : KEYGEN_STATE_TYPE := Idle;

   signal mode_encr     : std_logic := 'Z';
   signal crypto_start  : std_logic := '0';
   signal crypto_done   : std_logic := '0';

   signal crypto_state  : CRYPTO_STATE_TYPE := Idle;

   -- Counters to store the number inputs read & outputs written
   signal nr_of_reads  : natural range 0 to NUMBER_OF_INPUT_WORDS - 1;
   signal nr_of_writes : natural range 0 to NUMBER_OF_OUTPUT_WORDS - 1;

begin
   -- CAUTION:
   -- The sequence in which data are read in and written out should be
   -- consistent with the sequence they are written and read in the
   -- driver's present_hw_1.c file

   FSL_S_Read  <= FSL_S_Exists   when state = Read_Inputs   else '0';
   FSL_M_Write <= not FSL_M_Full when state = Write_Outputs else '0';

   with nr_of_writes select
   FSL_M_Data <= output_val(63 downto 32) when 1,
                 output_val(31 downto 0)  when 0,
                 (others => '0')          when others;

   key_generator : process(EXT_CLK)
    variable round_ctr_v : std_logic_vector(5 downto 0) := "000001";
    variable round_ctr   : natural range 1 to 32;
   begin
      if EXT_CLK'event and EXT_CLK='1' then
        if FSL_Rst = '1' then
          keygen_done  <= '0';
          keygen_state <= Idle;
        else
          case keygen_state is
            when Idle =>
              keygen_done <= '0';
              round_ctr_v := "000001";
              round_ctr   := 1;
              if keygen_start = '1' then
                key          <= key_in;
                keygen_state <= BarrelShift;
              end if ;
            when BarrelShift =>
              roundkey(round_ctr) <= key(79 downto 16);
              if round_ctr = 32 then
                keygen_done  <= '1';
                keygen_state <= Idle;
              else
                key <= std_logic_vector(unsigned(key) rol 61);
                keygen_state <= UpdateKey;
              end if ;
            when UpdateKey =>
              key(79 downto 76) <= sbox(key(79 downto 76));
              key(19 downto 15) <= key(19 downto 15) xor round_ctr_v(4 downto 0);
              round_ctr   := round_ctr + 1;
              round_ctr_v := std_logic_vector(unsigned(round_ctr_v) + "000001");
              keygen_state <= BarrelShift;
            when others =>
              keygen_state <= Idle;
          end case;
        end if;
      end if ;
   end process ; -- key_generator

   present_crypto : process(EXT_CLK)
    variable round_ctr : natural range 1 to 32;
   begin
     if  EXT_CLK'event and EXT_CLK='1' then
      if FSL_Rst = '1' then
        crypto_done  <= '0';
        crypto_state <= Idle;
      else
       case crypto_state is
        when Idle =>
          crypto_done <= '0';
          if crypto_start = '1' then
            if mode_encr = '1' then
              crypto_state <= Encrypt;
              crypto_sig   <= input_val;
              round_ctr    := 1;
            else
              crypto_state <= Decrypt;
              crypto_sig   <= input_val;
              round_ctr    := 32;
            end if ;
          end if ;
        when Encrypt =>
          crypto_sig     <= crypto_sig xor roundkey(round_ctr);
          if round_ctr = 32 then
            crypto_state <= Done;
          else
            round_ctr    := round_ctr + 1;
            crypto_state <= SBoxEnc;
          end if ;
        when SBoxEnc =>
          crypto_sig_t(63 downto 60) <= sbox(crypto_sig(63 downto 60));
          crypto_sig_t(59 downto 56) <= sbox(crypto_sig(59 downto 56));
          crypto_sig_t(55 downto 52) <= sbox(crypto_sig(55 downto 52));
          crypto_sig_t(51 downto 48) <= sbox(crypto_sig(51 downto 48));
          crypto_sig_t(47 downto 44) <= sbox(crypto_sig(47 downto 44));
          crypto_sig_t(43 downto 40) <= sbox(crypto_sig(43 downto 40));
          crypto_sig_t(39 downto 36) <= sbox(crypto_sig(39 downto 36));
          crypto_sig_t(35 downto 32) <= sbox(crypto_sig(35 downto 32));
          crypto_sig_t(31 downto 28) <= sbox(crypto_sig(31 downto 28));
          crypto_sig_t(27 downto 24) <= sbox(crypto_sig(27 downto 24));
          crypto_sig_t(23 downto 20) <= sbox(crypto_sig(23 downto 20));
          crypto_sig_t(19 downto 16) <= sbox(crypto_sig(19 downto 16));
          crypto_sig_t(15 downto 12) <= sbox(crypto_sig(15 downto 12));
          crypto_sig_t(11 downto  8) <= sbox(crypto_sig(11 downto  8));
          crypto_sig_t( 7 downto  4) <= sbox(crypto_sig( 7 downto  4));
          crypto_sig_t( 3 downto  0) <= sbox(crypto_sig( 3 downto  0));
          crypto_state               <= PLEnc;
        when PLEnc =>
          crypto_sig(0)  <= crypto_sig_t(0);
          crypto_sig(16) <= crypto_sig_t(1);
          crypto_sig(32) <= crypto_sig_t(2);
          crypto_sig(48) <= crypto_sig_t(3);
          crypto_sig(1)  <= crypto_sig_t(4);
          crypto_sig(17) <= crypto_sig_t(5);
          crypto_sig(33) <= crypto_sig_t(6);
          crypto_sig(49) <= crypto_sig_t(7);
          crypto_sig(2)  <= crypto_sig_t(8);
          crypto_sig(18) <= crypto_sig_t(9);
          crypto_sig(34) <= crypto_sig_t(10);
          crypto_sig(50) <= crypto_sig_t(11);
          crypto_sig(3)  <= crypto_sig_t(12);
          crypto_sig(19) <= crypto_sig_t(13);
          crypto_sig(35) <= crypto_sig_t(14);
          crypto_sig(51) <= crypto_sig_t(15);
          crypto_sig(4)  <= crypto_sig_t(16);
          crypto_sig(20) <= crypto_sig_t(17);
          crypto_sig(36) <= crypto_sig_t(18);
          crypto_sig(52) <= crypto_sig_t(19);
          crypto_sig(5)  <= crypto_sig_t(20);
          crypto_sig(21) <= crypto_sig_t(21);
          crypto_sig(37) <= crypto_sig_t(22);
          crypto_sig(53) <= crypto_sig_t(23);
          crypto_sig(6)  <= crypto_sig_t(24);
          crypto_sig(22) <= crypto_sig_t(25);
          crypto_sig(38) <= crypto_sig_t(26);
          crypto_sig(54) <= crypto_sig_t(27);
          crypto_sig(7)  <= crypto_sig_t(28);
          crypto_sig(23) <= crypto_sig_t(29);
          crypto_sig(39) <= crypto_sig_t(30);
          crypto_sig(55) <= crypto_sig_t(31);
          crypto_sig(8)  <= crypto_sig_t(32);
          crypto_sig(24) <= crypto_sig_t(33);
          crypto_sig(40) <= crypto_sig_t(34);
          crypto_sig(56) <= crypto_sig_t(35);
          crypto_sig(9)  <= crypto_sig_t(36);
          crypto_sig(25) <= crypto_sig_t(37);
          crypto_sig(41) <= crypto_sig_t(38);
          crypto_sig(57) <= crypto_sig_t(39);
          crypto_sig(10) <= crypto_sig_t(40);
          crypto_sig(26) <= crypto_sig_t(41);
          crypto_sig(42) <= crypto_sig_t(42);
          crypto_sig(58) <= crypto_sig_t(43);
          crypto_sig(11) <= crypto_sig_t(44);
          crypto_sig(27) <= crypto_sig_t(45);
          crypto_sig(43) <= crypto_sig_t(46);
          crypto_sig(59) <= crypto_sig_t(47);
          crypto_sig(12) <= crypto_sig_t(48);
          crypto_sig(28) <= crypto_sig_t(49);
          crypto_sig(44) <= crypto_sig_t(50);
          crypto_sig(60) <= crypto_sig_t(51);
          crypto_sig(13) <= crypto_sig_t(52);
          crypto_sig(29) <= crypto_sig_t(53);
          crypto_sig(45) <= crypto_sig_t(54);
          crypto_sig(61) <= crypto_sig_t(55);
          crypto_sig(14) <= crypto_sig_t(56);
          crypto_sig(30) <= crypto_sig_t(57);
          crypto_sig(46) <= crypto_sig_t(58);
          crypto_sig(62) <= crypto_sig_t(59);
          crypto_sig(15) <= crypto_sig_t(60);
          crypto_sig(31) <= crypto_sig_t(61);
          crypto_sig(47) <= crypto_sig_t(62);
          crypto_sig(63) <= crypto_sig_t(63);
          crypto_state   <= Encrypt;
        when Decrypt =>
          crypto_sig     <= crypto_sig xor roundkey(round_ctr);
          if round_ctr = 1 then
            crypto_state <= Done;
          else
            round_ctr    := round_ctr - 1;
            crypto_state <= PLDec;
          end if ;
        when PLDec =>
          crypto_sig_t(0) <= crypto_sig(0);
          crypto_sig_t(1) <= crypto_sig(16);
          crypto_sig_t(2) <= crypto_sig(32);
          crypto_sig_t(3) <= crypto_sig(48);
          crypto_sig_t(4) <= crypto_sig(1);
          crypto_sig_t(5) <= crypto_sig(17);
          crypto_sig_t(6) <= crypto_sig(33);
          crypto_sig_t(7) <= crypto_sig(49);
          crypto_sig_t(8) <= crypto_sig(2);
          crypto_sig_t(9) <= crypto_sig(18);
          crypto_sig_t(10) <= crypto_sig(34);
          crypto_sig_t(11) <= crypto_sig(50);
          crypto_sig_t(12) <= crypto_sig(3);
          crypto_sig_t(13) <= crypto_sig(19);
          crypto_sig_t(14) <= crypto_sig(35);
          crypto_sig_t(15) <= crypto_sig(51);
          crypto_sig_t(16) <= crypto_sig(4);
          crypto_sig_t(17) <= crypto_sig(20);
          crypto_sig_t(18) <= crypto_sig(36);
          crypto_sig_t(19) <= crypto_sig(52);
          crypto_sig_t(20) <= crypto_sig(5);
          crypto_sig_t(21) <= crypto_sig(21);
          crypto_sig_t(22) <= crypto_sig(37);
          crypto_sig_t(23) <= crypto_sig(53);
          crypto_sig_t(24) <= crypto_sig(6);
          crypto_sig_t(25) <= crypto_sig(22);
          crypto_sig_t(26) <= crypto_sig(38);
          crypto_sig_t(27) <= crypto_sig(54);
          crypto_sig_t(28) <= crypto_sig(7);
          crypto_sig_t(29) <= crypto_sig(23);
          crypto_sig_t(30) <= crypto_sig(39);
          crypto_sig_t(31) <= crypto_sig(55);
          crypto_sig_t(32) <= crypto_sig(8);
          crypto_sig_t(33) <= crypto_sig(24);
          crypto_sig_t(34) <= crypto_sig(40);
          crypto_sig_t(35) <= crypto_sig(56);
          crypto_sig_t(36) <= crypto_sig(9);
          crypto_sig_t(37) <= crypto_sig(25);
          crypto_sig_t(38) <= crypto_sig(41);
          crypto_sig_t(39) <= crypto_sig(57);
          crypto_sig_t(40) <= crypto_sig(10);
          crypto_sig_t(41) <= crypto_sig(26);
          crypto_sig_t(42) <= crypto_sig(42);
          crypto_sig_t(43) <= crypto_sig(58);
          crypto_sig_t(44) <= crypto_sig(11);
          crypto_sig_t(45) <= crypto_sig(27);
          crypto_sig_t(46) <= crypto_sig(43);
          crypto_sig_t(47) <= crypto_sig(59);
          crypto_sig_t(48) <= crypto_sig(12);
          crypto_sig_t(49) <= crypto_sig(28);
          crypto_sig_t(50) <= crypto_sig(44);
          crypto_sig_t(51) <= crypto_sig(60);
          crypto_sig_t(52) <= crypto_sig(13);
          crypto_sig_t(53) <= crypto_sig(29);
          crypto_sig_t(54) <= crypto_sig(45);
          crypto_sig_t(55) <= crypto_sig(61);
          crypto_sig_t(56) <= crypto_sig(14);
          crypto_sig_t(57) <= crypto_sig(30);
          crypto_sig_t(58) <= crypto_sig(46);
          crypto_sig_t(59) <= crypto_sig(62);
          crypto_sig_t(60) <= crypto_sig(15);
          crypto_sig_t(61) <= crypto_sig(31);
          crypto_sig_t(62) <= crypto_sig(47);
          crypto_sig_t(63) <= crypto_sig(63);
          crypto_state     <= SBoxDec;
        when SBoxDec =>
          crypto_sig(63 downto 60) <= inv_sbox(crypto_sig_t(63 downto 60));
          crypto_sig(59 downto 56) <= inv_sbox(crypto_sig_t(59 downto 56));
          crypto_sig(55 downto 52) <= inv_sbox(crypto_sig_t(55 downto 52));
          crypto_sig(51 downto 48) <= inv_sbox(crypto_sig_t(51 downto 48));
          crypto_sig(47 downto 44) <= inv_sbox(crypto_sig_t(47 downto 44));
          crypto_sig(43 downto 40) <= inv_sbox(crypto_sig_t(43 downto 40));
          crypto_sig(39 downto 36) <= inv_sbox(crypto_sig_t(39 downto 36));
          crypto_sig(35 downto 32) <= inv_sbox(crypto_sig_t(35 downto 32));
          crypto_sig(31 downto 28) <= inv_sbox(crypto_sig_t(31 downto 28));
          crypto_sig(27 downto 24) <= inv_sbox(crypto_sig_t(27 downto 24));
          crypto_sig(23 downto 20) <= inv_sbox(crypto_sig_t(23 downto 20));
          crypto_sig(19 downto 16) <= inv_sbox(crypto_sig_t(19 downto 16));
          crypto_sig(15 downto 12) <= inv_sbox(crypto_sig_t(15 downto 12));
          crypto_sig(11 downto  8) <= inv_sbox(crypto_sig_t(11 downto  8));
          crypto_sig( 7 downto  4) <= inv_sbox(crypto_sig_t( 7 downto  4));
          crypto_sig( 3 downto  0) <= inv_sbox(crypto_sig_t( 3 downto  0));
          crypto_state             <= Decrypt;
        when Done =>
          output_val   <= crypto_sig;
          crypto_done  <= '1';
          crypto_state <= Idle;
        end case ;
      end if;
     end if ;
   end process ; -- present_crypto

   FSL_Handler : process (FSL_Clk) is
   begin  -- process FSL_Handler
    if FSL_Clk'event and FSL_Clk = '1' then     -- Rising clock edge
      if FSL_Rst = '1' then               -- Synchronous reset (active high)
        -- CAUTION: make sure your reset polarity is consistent with the
        -- system reset polarity
        state        <= Idle;
        keygen_start <= '0';
        crypto_start <= '0';
        nr_of_reads  <= 0;
        nr_of_writes <= 0;
      else
        case state is
          when Idle =>
            if (FSL_S_Exists = '1') then
              state       <= Read_Inputs;
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;
            end if;

          when Read_Inputs =>
            if (FSL_S_Exists = '1') then
              -- Coprocessor function (Adding) happens here
              case nr_of_reads is
                when 4 =>
                  mode_encr               <= FSL_S_Data(0);
                  key_in(79 downto 64)       <= FSL_S_Data(16 to 31);
                when 3 =>
                  key_in(63 downto 32)       <= FSL_S_Data;
                when 2 =>
                  key_in(31 downto 0)        <= FSL_S_Data;
                  keygen_start            <= '1';
                when 1 =>
                  input_val(63 downto 32) <= FSL_S_Data;
                  keygen_start            <= '0';
                when 0 =>
                  input_val(31 downto 0)  <= FSL_S_Data;
              end case;
              if (nr_of_reads = 0) then
                state        <= Processing;
              else
                nr_of_reads <= nr_of_reads - 1;
              end if;
            end if;

          when Processing =>

            if (crypto_done = '1') then
              nr_of_writes <= NUMBER_OF_OUTPUT_WORDS - 1;
              state        <= Write_Outputs;
            end if;

            if (crypto_start = '1') then
              crypto_start <= '0';
            elsif (keygen_done = '1') then
              crypto_start <= '1';
            end if;

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
   end process FSL_Handler;
end architecture EXAMPLE;
