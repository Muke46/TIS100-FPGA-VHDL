--! Test workflow
--! 

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        ADDRESS_BITS  : integer := 3;
        OUTPUTS_N     : integer := 6
    );
end entity testbench; 

architecture tb of testbench is
    -- DUT component
    
    component SRC_ADDR_DEC is
        port(
        clk         : in  std_logic;
        i_address   : in  unsigned(ADDRESS_BITS-1 downto 0);
        i_OutEn     : in  std_logic;
        o_control   : out unsigned(OUTPUTS_N-1 downto 0) := (others => '0')
    );
    end component;

    signal address_tb : unsigned(ADDRESS_BITS-1 downto 0):= (others => '0');
    signal o_control  : unsigned(OUTPUTS_N-1 downto 0);
    signal clk, OutEn : std_logic := '0';

    begin
        DUT: SRC_ADDR_DEC port map(clk, address_tb, OutEn, o_control);

        process
        begin
            report "Starting test" severity note;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            OutEn <= '1';
            address_tb <= "010";
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            OutEn <= '1';
            address_tb <= "001";
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            OutEn <= '0';
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            OutEn <= '1';
            address_tb <= "110";
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;

            assert false report "Test done." severity note;
            wait;
        end process;

    end architecture;