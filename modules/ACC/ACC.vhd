--! ACC register
--! Input/Output sync, flags comb.
--! Stores a 11-bit signed value
--! One input, switched with an external mux between ALU and BKP
--! One output, to bus
--! Control pins to enable the inputs and the output
--! Output flag for:
--!                 ACC  = 0
--!                 ACC != 0
--!                 ACC  > 0
--!                 ACC  < 0
--! Notes:
--! The output flags are not encoded in two bits because in that way it will need a decoder on the other side, which probably complicates the design.

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ACC is
    generic(
        DATA_BITS  : integer := 11
    );

    port(
        clk        : in  std_logic;
        i_dataIn   : in  signed(DATA_BITS-1 downto 0);
        i_inEn     : in  std_logic;
        i_outEn    : in  std_logic;
        o_dataOut  : out signed(DATA_BITS-1 downto 0);
        o_flags    : out std_logic_vector(3 downto 0)
    );

end ACC;

architecture arch of ACC is
    signal data    : signed(DATA_BITS-1 downto 0) := (others => '0');
    begin
        process(clk)
            begin
                if rising_edge(clk) then
                    data       <= i_dataIn when i_inEn  = '1' else data; --store data if enabled
                    o_dataOut  <= data     when i_outEn = '1' else (others => 'Z'); --put data to bus if enabled
                end if;
        end process;

        process (data)
            begin
            o_flags(0) <= '1' when data =  signed(to_signed(0, DATA_BITS))  else '0'; -- ACC=0 flag
            o_flags(1) <= '1' when data /= signed(to_signed(0, DATA_BITS))  else '0'; -- ACC!=0 flag
            o_flags(2) <= '1' when data >  signed(to_signed(0, DATA_BITS))  else '0'; -- ACC>0 flag
            o_flags(3) <= '1' when data <  signed(to_signed(0, DATA_BITS))  else '0'; -- ACC<0 flag
        end process;
    end arch;