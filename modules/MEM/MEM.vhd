library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mem is
    generic(
        ADDR_BITS  : integer := 4;
        DATA_LINES : integer := 15;
        MEM_BITS  : integer := 16
    );

    port(
        i_address  : in  unsigned(ADDR_BITS-1 downto 0);
        o_data     : out std_logic_vector(MEM_BITS-1 downto 0)  
    );
end mem;

architecture arch of mem is
    type mem_array is array (DATA_LINES downto 0) of std_logic_vector(MEM_BITS - 1 downto 0);
    constant mem_data : mem_array := (
        0  => "0000000000000001",
        1  => "0000000000000010",
        2  => "0000000000000100",
        3  => "0000000000001000",
        4  => "0000000000010000",
        5  => "0000000000100000",
        6  => "0000000001000000",
        7  => "0000000010000000",
        8  => "0000000100000000",
        9  => "0000001000000000",
        10 => "0000010000000000",
        11 => "0000100000000000",
        12 => "0001000000000000",
        13 => "0010000000000000",
        14 => "0100000000000000",
        
        others => (others => '0')
      );

    begin
        process(all)
            begin
                o_data <= mem_data(to_integer(i_address));
            end process;
    end arch;