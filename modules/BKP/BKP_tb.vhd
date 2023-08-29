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
    
    component BKP is
        port(
        clk        : in  std_logic;
        i_dataIn   : in  signed(DATA_BITS-1 downto 0);
        i_En       : in  std_logic;
        o_dataOut  : out signed(DATA_BITS-1 downto 0)
    );
    end component;

    signal dataIn, dataOut : signed(DATA_BITS-1 downto 0):= (others => '0');

    signal clk, En: std_logic := '0';

    begin
        DUT: BKP port map(clk, dataIn, En, dataOut);

        process
        begin
            report "Starting test" severity note;
            report "Loading 1 in BKP" severity note;
            clk <= '0';
            dataIn <= signed(to_signed(1, DATA_BITS));
            En <= '1';

            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            clk <= '0';
            En <= '0';
            report "Wait a cycle" severity note;
            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            report "Loading -99 in BKP" severity note;
            dataIn <= signed(to_signed(-99, DATA_BITS));
            En <= '1';
            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;
            clk <= '0';
            assert dataOut = signed(to_signed(1, DATA_BITS))  report "Returned value different from the stored one" severity error;
            En <= '0';
            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;

            assert false report "Test done." severity note;
            wait;
        end process;

    end architecture;