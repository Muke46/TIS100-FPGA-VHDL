--! Program Counter
--! Starts from zero, if cont_En is active, it counts up at every clock cycle
--! 4 bits, counts up to 15, then resets to 0
--! Has an input that overwrites the current counter, with an associated control pin
--!
--! Notes: maybe should work on the clock negative edge?

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity PC is
    generic(
        ADDRESS_BITS  : integer := 4
    );

    port(
        clk         : in  std_logic;
        i_address   : in  unsigned(ADDRESS_BITS-1 downto 0);
        i_IncEn     : in  std_logic;
        i_OwEn      : in  std_logic;
        o_address   : out unsigned(ADDRESS_BITS-1 downto 0) := (others => '0')
    );

end PC;

architecture arch of PC is
    begin
        process(clk)
            begin
                if falling_edge(clk) then

                    if i_OwEn = '1' then
                        o_address <= i_address;
                    elsif i_IncEn then
                        o_address <= unsigned(o_address + to_unsigned(1, ADDRESS_BITS));
                    else
                    o_address <= o_address;
                    end if;

                end if;
        end process;
    end arch;