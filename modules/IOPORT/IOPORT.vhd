--! Passes data between two data busses of two processors.
--! The bridge is active only when the input enable of one side and the output enable of the other side are active
--! Comb. design
--!
--! Notes: need to define the proper behaviour in case of multiple access
--!        If both sides try to put data at the same time, they will halt -> condition checked outside this module

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity IOPORT is
    generic(
        DATA_BITS  : integer := 11
    );

    port(
        io_data0   : inout  signed(DATA_BITS-1 downto 0);
        io_data1   : inout  signed(DATA_BITS-1 downto 0);
        i_InEn0    : in  std_logic;
        i_OutEn0   : in  std_logic;
        i_InEn1    : in  std_logic;
        i_OutEn1   : in  std_logic
    );

end IOPORT;

architecture arch of IOPORT is
    signal data    : signed(DATA_BITS-1 downto 0) := (others => '0');
    begin
        process(all)
            begin

            if i_InEn0 = '1' and i_OutEn1 = '1' then
                io_data1 <= io_data0;
            else
                io_data1 <= (others => 'Z');
            end if;

            if i_InEn1 = '1' and i_OutEn0 = '1' then
                io_data0 <= io_data1;
            else
                io_data0 <= (others => 'Z');
            end if;

        end process;
    end arch;