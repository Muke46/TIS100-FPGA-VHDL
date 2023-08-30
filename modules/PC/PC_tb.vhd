--! Test workflow
--! one clock cycle with both enables disabled, the address should stay at 0
--! enable IncEn for 2 clock cycles, the address should increase
--! enable OverWrite without disabling IncEn and put an address on the input
--! the address should update to the new value
--! disable IncEn and put another value on the input
--! disable OW, enable IncEn and leave the clock running to see if the address goes to 15 and back to 0

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        ADDRESS_BITS  : integer := 4
    );
end entity testbench; 

architecture tb of testbench is
    -- DUT component
    
    component PC is
        port(
        clk         : in  std_logic;
        i_address   : in  unsigned(ADDRESS_BITS-1 downto 0);
        i_IncEn     : in  std_logic;
        i_OwEn      : in  std_logic;
        o_address   : out unsigned(ADDRESS_BITS-1 downto 0) := (others => '0')
    );
    end component;

    signal addressOut, addressIN : unsigned(ADDRESS_BITS-1 downto 0):= (others => '0');

    signal clk, IncEn, OwEn : std_logic := '0';

    begin
        DUT: PC port map(clk, addressIN, IncEn, OwEn , addressOut);

        process
        begin
            report "Starting test" severity note;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            IncEn <= '1';
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 1 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            OwEn <= '1';
            addressIN <= to_unsigned(11, ADDRESS_BITS);
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            IncEn <= '0';
            addressIN <= to_unsigned(14, ADDRESS_BITS);
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            IncEn <= '1';
            OwEn <= '0';
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