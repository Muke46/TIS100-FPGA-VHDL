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
    
    component ACC is
        port(
        clk        : in  std_logic;
        i_dataIn   : in  signed(DATA_BITS-1 downto 0);
        i_inEn     : in  std_logic;
        i_outEn    : in  std_logic;
        o_dataOut  : out signed(DATA_BITS-1 downto 0);
        o_flags    : out std_logic_vector(3 downto 0)
        );
    end component;

    signal dataIn, dataOut : signed(DATA_BITS-1 downto 0):= (others => '0');
    signal flags : std_logic_vector(3 downto 0);
    signal clk, inEn, outEn : std_logic := '0';

    begin
        DUT: ACC port map(clk, dataIn, inEn, outEn, dataOut, flags);

        process
        begin
            report "Starting test" severity note;
            report "Loading 0 in ACC" severity note;
            clk <= '0';
            dataIn <= signed(to_signed(0, DATA_BITS));
            inEn <= '1';
            outEn <= '1';

            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            assert flags(0) = '1' report "FLAG EZ ERROR" severity error;
            assert flags(1) = '0' report "FLAG NZ ERROR" severity error;
            assert flags(2) = '0' report "FLAG GZ ERROR" severity error;
            assert flags(3) = '0' report "FLAG LZ ERROR" severity error;

            report "Loading 1 in ACC" severity note;
            clk <= '0';
            dataIn <= signed(to_signed(1, DATA_BITS));
            inEn <= '1';

            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            assert flags(0) = '0' report "FLAG EZ ERROR" severity error;
            assert flags(1) = '1' report "FLAG NZ ERROR" severity error;
            assert flags(2) = '1' report "FLAG GZ ERROR" severity error;
            assert flags(3) = '0' report "FLAG LZ ERROR" severity error;

            report "Loading -1 in ACC" severity note;
            clk <= '0';
            dataIn <= signed(to_signed(-1, DATA_BITS));
            inEn <= '1';
            outEn <= '0';

            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            assert flags(0) = '0' report "FLAG EZ ERROR" severity error;
            assert flags(1) = '1' report "FLAG NZ ERROR" severity error;
            assert flags(2) = '0' report "FLAG GZ ERROR" severity error;
            assert flags(3) = '1' report "FLAG LZ ERROR" severity error;

            report "Loading 999 in ACC" severity note;
            clk <= '0';
            dataIn <= signed(to_signed(999, DATA_BITS));
            inEn <= '1';

            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            assert flags(0) = '0' report "FLAG EZ ERROR" severity error;
            assert flags(1) = '1' report "FLAG NZ ERROR" severity error;
            assert flags(2) = '1' report "FLAG GZ ERROR" severity error;
            assert flags(3) = '0' report "FLAG LZ ERROR" severity error;

            assert false report "Test done." severity note;
            wait;
        end process;

    end architecture;