library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        DATA_BITS  : integer := 11
    );
end entity testbench; 

architecture tb of testbench is

    --signal address_tb : unsigned(ADDRESS_BITS-1 downto 0):= (others => '0');
    --signal o_control  : unsigned(OUTPUTS_N-1 downto 0);
    --signal clk, OutEn : std_logic := '0';
    signal clk      :   std_logic := '0';

    signal alu_a    :   signed(DATA_BITS-1 downto 0);
    signal alu_b    :   signed(DATA_BITS-1 downto 0);
    signal alu_o    :   signed(DATA_BITS-1 downto 0);
    signal alu_op   :   std_logic_vector(1 downto 0);

    signal bus_data :   signed(DATA_BITS-1 downto 0);

    signal acc_inEn :   std_logic := '0';
    signal acc_outEn:   std_logic := '0';
    signal acc_flgs :   std_logic_vector(3 downto 0);


    begin
        --DUT: SRC_ADDR_DEC port map(clk, address_tb, OutEn, o_control);
        --DUT: entity work.TOP(arch)
        --    port map (clk, address_tb, OutEn, o_control);

        ALU: entity work.ALU(arch)
            generic map (DATA_BITS => DATA_BITS)
            port map (
                i_a     =>  bus_data, --TODO add mux
                i_b     =>  alu_b,
                i_op    =>  alu_op,
                o_out   =>  alu_o
            );
        
        ACC: entity work.ACC(arch)
            generic map (DATA_BITS => DATA_BITS)
            port map (
                clk       =>  clk,  
                i_dataIn  =>  alu_o, --TODO add mux
                i_inEn    =>  acc_inEn,
                i_outEn   =>  acc_outEn,
                o_dataOut =>  bus_data,
                o_flags   =>  acc_flgs
            );

        process
        begin
            report "Starting test" severity note;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            --load 1 in ACC
            alu_b       <=  to_signed(1, DATA_BITS);
            alu_op      <=  "11";
            acc_inEn    <=  '1';
            acc_outEn   <=  '1';
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            alu_op      <=  "00";
            --address_tb <= "001";
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            --OutEn <= '0';
            wait for 0.8 ns;

            clk <= '0';
            wait for 1 ns;

            clk <= '1';
            wait for 0.2 ns;
            --OutEn <= '1';
            --address_tb <= "110";
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