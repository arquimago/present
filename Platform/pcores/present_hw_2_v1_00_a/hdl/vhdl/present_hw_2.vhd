------------------------------------------------------------------------------
-- present_hw_2 - entity/architecture pair
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
-- Filename:          present_hw_2
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Mon Apr 02 12:08:10 2012 (by Create and Import Peripheral Wizard)
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

entity present_hw_2 is
   port 
   (
      -- DO NOT EDIT BELOW THIS LINE ---------------------
      -- Bus protocol ports, do not add or delete. 
      FSL_Clk  : in  std_logic;
      FSL_Rst  : in  std_logic;
      FSL_S_Clk   : in  std_logic;
      FSL_S_Read  : out std_logic;
      FSL_S_Data  : in  std_logic_vector(0 to 31);
      FSL_S_Control  : in  std_logic;
      FSL_S_Exists   : in  std_logic;
      FSL_M_Clk   : in  std_logic;
      FSL_M_Write : out std_logic;
      FSL_M_Data  : out std_logic_vector(0 to 31);
      FSL_M_Control  : out std_logic;
      FSL_M_Full  : in  std_logic;
      -- DO NOT EDIT ABOVE THIS LINE ---------------------
    EXT_CLK     : in std_logic
   );

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
attribute SIGIS of FSL_M_Clk : signal is "Clk"; 
attribute SIGIS of EXT_CLK : signal is "Clk";

end present_hw_2;

------------------------------------------------------------------------------
-- Architecture Section
------------------------------------------------------------------------------

-- In this section, we povide an example implementation of ENTITY present_hw_2
-- that does the following:
--
-- 1. Read all inputs
-- 2. Add each input to the contents of register 'sum' which
--    acts as an accumulator
-- 3. After all the inputs have been read, write out the
--    content of 'sum' into the output FSL bus NUMBER_OF_OUTPUT_WORDS times
--
-- You will need to modify this example or implement a new architecture for
-- ENTITY present_hw_2 to implement your coprocessor

architecture EXAMPLE of present_hw_2 is

   -- Total number of input data.
   constant NUMBER_OF_INPUT_WORDS  : natural := 5;

   -- Total number of output data
   constant NUMBER_OF_OUTPUT_WORDS : natural := 2;

   type STATE_TYPE is (Idle, Read_Inputs, Processing, Write_Outputs);

   signal state        : STATE_TYPE;

   -- PRESENT types

   type ROUNDKEY_TYPE is array(1 to 32) of std_logic_vector(63 downto 0);
   type KEYGEN_STATE_TYPE is (Idle, GetRoundKey);
   type CRYPTO_STATE_TYPE is (Idle, Encrypt, Decrypt, Done);

   -- PRESENT Signals
   signal input_val     : std_logic_vector(63 downto 0);
   signal output_val    : std_logic_vector(63 downto 0);
   signal key_in        : std_logic_vector(79 downto 0);

   signal roundkey      : ROUNDKEY_TYPE;

   signal round_ctr_s   : natural range 1 to 32;
   signal round_ctr_v   : std_logic_vector(5 downto 0) := "000001";

   signal crypto_sig    : std_logic_vector(63 downto 0);

   signal crypto_sig_x  : std_logic_vector(63 downto 0);
   signal to_player     : std_logic_vector(63 downto 0);
   signal from_player   : std_logic_vector(63 downto 0);
   signal to_isbox      : std_logic_vector(63 downto 0);
   signal from_isbox    : std_logic_vector(63 downto 0);

   signal ukey_in       : std_logic_vector(79 downto 0);
   signal ukey_rol      : std_logic_vector(79 downto 0);
   signal ukey_out      : std_logic_vector(79 downto 0);

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
   -- driver's present_hw_2.c file

   FSL_S_Read  <= FSL_S_Exists   when state = Read_Inputs   else '0';
   FSL_M_Write <= not FSL_M_Full when state = Write_Outputs else '0';

   with nr_of_writes select
   FSL_M_Data <= output_val(63 downto 32) when 1,
                 output_val(31 downto 0)  when 0,
                 (others => '0')          when others;

   
   -- Concurrent ARK
   crypto_sig_x <= crypto_sig xor roundkey(round_ctr_s);

   -- Concurrent Sbox BEGIN
   to_player(63 downto 60) <= sbox(crypto_sig_x(63 downto 60));
   to_player(59 downto 56) <= sbox(crypto_sig_x(59 downto 56));
   to_player(55 downto 52) <= sbox(crypto_sig_x(55 downto 52));
   to_player(51 downto 48) <= sbox(crypto_sig_x(51 downto 48));
   to_player(47 downto 44) <= sbox(crypto_sig_x(47 downto 44));
   to_player(43 downto 40) <= sbox(crypto_sig_x(43 downto 40));
   to_player(39 downto 36) <= sbox(crypto_sig_x(39 downto 36));
   to_player(35 downto 32) <= sbox(crypto_sig_x(35 downto 32));
   to_player(31 downto 28) <= sbox(crypto_sig_x(31 downto 28));
   to_player(27 downto 24) <= sbox(crypto_sig_x(27 downto 24));
   to_player(23 downto 20) <= sbox(crypto_sig_x(23 downto 20));
   to_player(19 downto 16) <= sbox(crypto_sig_x(19 downto 16));
   to_player(15 downto 12) <= sbox(crypto_sig_x(15 downto 12));
   to_player(11 downto  8) <= sbox(crypto_sig_x(11 downto  8));
   to_player( 7 downto  4) <= sbox(crypto_sig_x( 7 downto  4));
   to_player( 3 downto  0) <= sbox(crypto_sig_x( 3 downto  0));
   -- Concurrent Sbox END

   -- Concurrent InvSbox BEGIN
   from_isbox(63 downto 60) <= inv_sbox(to_isbox(63 downto 60));
   from_isbox(59 downto 56) <= inv_sbox(to_isbox(59 downto 56));
   from_isbox(55 downto 52) <= inv_sbox(to_isbox(55 downto 52));
   from_isbox(51 downto 48) <= inv_sbox(to_isbox(51 downto 48));
   from_isbox(47 downto 44) <= inv_sbox(to_isbox(47 downto 44));
   from_isbox(43 downto 40) <= inv_sbox(to_isbox(43 downto 40));
   from_isbox(39 downto 36) <= inv_sbox(to_isbox(39 downto 36));
   from_isbox(35 downto 32) <= inv_sbox(to_isbox(35 downto 32));
   from_isbox(31 downto 28) <= inv_sbox(to_isbox(31 downto 28));
   from_isbox(27 downto 24) <= inv_sbox(to_isbox(27 downto 24));
   from_isbox(23 downto 20) <= inv_sbox(to_isbox(23 downto 20));
   from_isbox(19 downto 16) <= inv_sbox(to_isbox(19 downto 16));
   from_isbox(15 downto 12) <= inv_sbox(to_isbox(15 downto 12));
   from_isbox(11 downto  8) <= inv_sbox(to_isbox(11 downto  8));
   from_isbox( 7 downto  4) <= inv_sbox(to_isbox( 7 downto  4));
   from_isbox( 3 downto  0) <= inv_sbox(to_isbox( 3 downto  0));
   -- Concurrent InvSbox END

   -- Concurrent PLayer BEGIN
   from_player(0)  <= to_player(0);
   from_player(16) <= to_player(1);
   from_player(32) <= to_player(2);
   from_player(48) <= to_player(3);
   from_player(1)  <= to_player(4);
   from_player(17) <= to_player(5);
   from_player(33) <= to_player(6);
   from_player(49) <= to_player(7);
   from_player(2)  <= to_player(8);
   from_player(18) <= to_player(9);
   from_player(34) <= to_player(10);
   from_player(50) <= to_player(11);
   from_player(3)  <= to_player(12);
   from_player(19) <= to_player(13);
   from_player(35) <= to_player(14);
   from_player(51) <= to_player(15);
   from_player(4)  <= to_player(16);
   from_player(20) <= to_player(17);
   from_player(36) <= to_player(18);
   from_player(52) <= to_player(19);
   from_player(5)  <= to_player(20);
   from_player(21) <= to_player(21);
   from_player(37) <= to_player(22);
   from_player(53) <= to_player(23);
   from_player(6)  <= to_player(24);
   from_player(22) <= to_player(25);
   from_player(38) <= to_player(26);
   from_player(54) <= to_player(27);
   from_player(7)  <= to_player(28);
   from_player(23) <= to_player(29);
   from_player(39) <= to_player(30);
   from_player(55) <= to_player(31);
   from_player(8)  <= to_player(32);
   from_player(24) <= to_player(33);
   from_player(40) <= to_player(34);
   from_player(56) <= to_player(35);
   from_player(9)  <= to_player(36);
   from_player(25) <= to_player(37);
   from_player(41) <= to_player(38);
   from_player(57) <= to_player(39);
   from_player(10) <= to_player(40);
   from_player(26) <= to_player(41);
   from_player(42) <= to_player(42);
   from_player(58) <= to_player(43);
   from_player(11) <= to_player(44);
   from_player(27) <= to_player(45);
   from_player(43) <= to_player(46);
   from_player(59) <= to_player(47);
   from_player(12) <= to_player(48);
   from_player(28) <= to_player(49);
   from_player(44) <= to_player(50);
   from_player(60) <= to_player(51);
   from_player(13) <= to_player(52);
   from_player(29) <= to_player(53);
   from_player(45) <= to_player(54);
   from_player(61) <= to_player(55);
   from_player(14) <= to_player(56);
   from_player(30) <= to_player(57);
   from_player(46) <= to_player(58);
   from_player(62) <= to_player(59);
   from_player(15) <= to_player(60);
   from_player(31) <= to_player(61);
   from_player(47) <= to_player(62);
   from_player(63) <= to_player(63);
   -- Concurrent PLayer END

   -- Concurrent InvPLayer BEGIN
   to_isbox(0) <= crypto_sig_x(0);
   to_isbox(1) <= crypto_sig_x(16);
   to_isbox(2) <= crypto_sig_x(32);
   to_isbox(3) <= crypto_sig_x(48);
   to_isbox(4) <= crypto_sig_x(1);
   to_isbox(5) <= crypto_sig_x(17);
   to_isbox(6) <= crypto_sig_x(33);
   to_isbox(7) <= crypto_sig_x(49);
   to_isbox(8) <= crypto_sig_x(2);
   to_isbox(9) <= crypto_sig_x(18);
   to_isbox(10) <= crypto_sig_x(34);
   to_isbox(11) <= crypto_sig_x(50);
   to_isbox(12) <= crypto_sig_x(3);
   to_isbox(13) <= crypto_sig_x(19);
   to_isbox(14) <= crypto_sig_x(35);
   to_isbox(15) <= crypto_sig_x(51);
   to_isbox(16) <= crypto_sig_x(4);
   to_isbox(17) <= crypto_sig_x(20);
   to_isbox(18) <= crypto_sig_x(36);
   to_isbox(19) <= crypto_sig_x(52);
   to_isbox(20) <= crypto_sig_x(5);
   to_isbox(21) <= crypto_sig_x(21);
   to_isbox(22) <= crypto_sig_x(37);
   to_isbox(23) <= crypto_sig_x(53);
   to_isbox(24) <= crypto_sig_x(6);
   to_isbox(25) <= crypto_sig_x(22);
   to_isbox(26) <= crypto_sig_x(38);
   to_isbox(27) <= crypto_sig_x(54);
   to_isbox(28) <= crypto_sig_x(7);
   to_isbox(29) <= crypto_sig_x(23);
   to_isbox(30) <= crypto_sig_x(39);
   to_isbox(31) <= crypto_sig_x(55);
   to_isbox(32) <= crypto_sig_x(8);
   to_isbox(33) <= crypto_sig_x(24);
   to_isbox(34) <= crypto_sig_x(40);
   to_isbox(35) <= crypto_sig_x(56);
   to_isbox(36) <= crypto_sig_x(9);
   to_isbox(37) <= crypto_sig_x(25);
   to_isbox(38) <= crypto_sig_x(41);
   to_isbox(39) <= crypto_sig_x(57);
   to_isbox(40) <= crypto_sig_x(10);
   to_isbox(41) <= crypto_sig_x(26);
   to_isbox(42) <= crypto_sig_x(42);
   to_isbox(43) <= crypto_sig_x(58);
   to_isbox(44) <= crypto_sig_x(11);
   to_isbox(45) <= crypto_sig_x(27);
   to_isbox(46) <= crypto_sig_x(43);
   to_isbox(47) <= crypto_sig_x(59);
   to_isbox(48) <= crypto_sig_x(12);
   to_isbox(49) <= crypto_sig_x(28);
   to_isbox(50) <= crypto_sig_x(44);
   to_isbox(51) <= crypto_sig_x(60);
   to_isbox(52) <= crypto_sig_x(13);
   to_isbox(53) <= crypto_sig_x(29);
   to_isbox(54) <= crypto_sig_x(45);
   to_isbox(55) <= crypto_sig_x(61);
   to_isbox(56) <= crypto_sig_x(14);
   to_isbox(57) <= crypto_sig_x(30);
   to_isbox(58) <= crypto_sig_x(46);
   to_isbox(59) <= crypto_sig_x(62);
   to_isbox(60) <= crypto_sig_x(15);
   to_isbox(61) <= crypto_sig_x(31);
   to_isbox(62) <= crypto_sig_x(47);
   to_isbox(63) <= crypto_sig_x(63);
   -- Concurrent InvPLayer END

   ukey_rol <= std_logic_vector(unsigned(ukey_in) rol 61);
   ukey_out(79 downto 76) <= sbox(ukey_rol(79 downto 76));
   ukey_out(75 downto 20) <= ukey_rol(75 downto 20);
   ukey_out(19 downto 15) <= ukey_rol(19 downto 15) xor round_ctr_v(4 downto 0);
   ukey_out(14 downto 0) <= ukey_rol(14 downto 0);


   key_generator : process(EXT_CLK)
    variable round_ctr   : natural range 1 to 32;
   begin
      if EXT_CLK'event and EXT_CLK='1' then
        if FSL_Rst = '1' then
          keygen_done  <= '0';
          round_ctr    := 1;
          round_ctr_v  <= "000001";
          ukey_in      <= (others => '0');
          keygen_state <= Idle;
        else
          case keygen_state is
            when Idle =>
              keygen_done <= '0';
              round_ctr_v <= "000001";
              round_ctr   := 1;
              if keygen_start = '1' then
                ukey_in      <= key_in;
                keygen_state <= GetRoundKey;
              end if ;
            when GetRoundKey =>
              roundkey(round_ctr) <= ukey_in(79 downto 16);
              ukey_in             <= ukey_out;
              if round_ctr = 32 then
                keygen_done  <= '1';
                keygen_state <= Idle;
              else
                round_ctr   := round_ctr + 1;
                round_ctr_v <= std_logic_vector(unsigned(round_ctr_v) + "000001");
              end if ;
            when others =>
              keygen_state <= Idle;
          end case;
        end if;
      end if ;
   end process ; -- key_generator

   present_crypto : process(EXT_CLK)
   begin
     if  EXT_CLK'event and EXT_CLK='1' then
      if FSL_Rst = '1' then
        crypto_done  <= '0';
        round_ctr_s  <= 1;
        crypto_sig   <= (others => '0');
        crypto_state <= Idle;
      else
       case crypto_state is
        when Idle =>
          crypto_done <= '0';
          if crypto_start = '1' then
            if mode_encr = '1' then
              crypto_state <= Encrypt;
              crypto_sig   <= input_val;
              round_ctr_s  <= 1;
            else
              crypto_state <= Decrypt;
              crypto_sig   <= input_val;
              round_ctr_s  <= 32;
            end if ;
          end if ;
        when Encrypt =>
          if round_ctr_s = 32 then
            crypto_sig   <= crypto_sig_x;
            crypto_state <= Done;
          else
            crypto_sig   <= from_player;
            round_ctr_s  <= round_ctr_s + 1;
          end if ;
        when Decrypt =>
          if round_ctr_s = 1 then
            crypto_sig   <= crypto_sig_x;
            crypto_state <= Done;
          else
            crypto_sig   <= from_isbox;
            round_ctr_s  <= round_ctr_s - 1;
          end if ;
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
        key_in       <= (others => '0');
        input_val    <= (others => '0');
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
