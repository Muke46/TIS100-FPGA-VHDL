library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        ADDR_BITS  : integer := 4;
        DATA_LINES : integer := 15;
        DATA_BITS  : integer := 16
    );
end entity testbench; 

architecture tb of testbench is
    -- DUT component
    
    component mem is
        port(
            i_address  : in  std_logic_vector(ADDR_BITS-1 downto 0);
            o_data     : out std_logic_vector(DATA_BITS-1 downto 0)  
        );
    end component;

    signal address  : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
    signal data     : std_logic_vector(DATA_BITS-1 downto 0);

    begin
        DUT: mem port map(address, data);

        process
        begin
            address <= (others => '0');

            for i in 0 to DATA_LINES-1 loop

                wait for 1 ns;
                --address <= "0001";
                address <= std_logic_vector(to_unsigned(i, 4));
                --address <= std_logic_vector(to_unsigned(address, address'length) + to_unsigned(1,1));

            end loop;

            assert false report "Test done." severity note;
            wait;
        end process;
    end architecture;