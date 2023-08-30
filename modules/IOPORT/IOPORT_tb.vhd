--insert data from port 0
--wait

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        DATA_BITS  : integer := 11
    );
end entity testbench; 

architecture tb of testbench is
    -- DUT component
    
    component IOPORT is
        port(
        io_data0   : in  signed(DATA_BITS-1 downto 0);
        io_data1   : in  signed(DATA_BITS-1 downto 0);
        i_InEn0    : in  std_logic;
        i_OutEn0   : in  std_logic;
        i_InEn1    : in  std_logic;
        i_OutEn1   : in  std_logic
    );
    end component;

    signal data0, data1 : signed(DATA_BITS-1 downto 0):= (others => '0');

    signal InEn0, OutEn0, InEn1, OutEn1: std_logic := '0';

    begin
        DUT: IOPORT port map(data0, data1, InEn0, OutEn0, InEn1, OutEn1);

        process
        begin
            report "TODO test" severity note;

            assert false report "Test done." severity note;
            wait;
        end process;

    end architecture;