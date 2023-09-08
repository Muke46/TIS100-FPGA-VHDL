--! BKP register
--! Input/Output sync
--! Stores a 11-bit signed value
--! One input and one output, both controlled by an enable pin

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity BKP is
    generic(
        DATA_BITS  : integer := 11
    );

    port(
        clk        : in  std_logic;
        i_dataIn   : in  signed(DATA_BITS-1 downto 0);
        i_En       : in  std_logic;
        o_dataOut  : out signed(DATA_BITS-1 downto 0)
    );

end BKP;

architecture arch of BKP is
    signal data    : signed(DATA_BITS-1 downto 0) := (others => '0');
    begin
        data_in: process(clk) begin
            if rising_edge(clk) then
                data       <= i_dataIn when i_En  = '1' else data; --store data if enabled
            end if;
        end process;

        data_out: process(all) begin
            o_dataOut  <= data     when i_En  = '1' else (others => 'Z'); --put data to bus if enabled
        end process;

    end arch;