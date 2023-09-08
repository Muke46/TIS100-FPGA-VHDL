library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
 
entity testbench is
    generic(
        DATA_BITS   : integer := 11;
        ADDRESS_BITS: integer := 4;
        MEM_BITS    : integer := 16
    );
end entity testbench; 

architecture tb of testbench is
    
    signal clk      :   std_logic := '0';
    
    --control pins
    signal alu_op   :   std_logic_vector(1 downto 0);

    signal acc_inEn :   std_logic := '0';
    signal acc_outEn:   std_logic := '0';
    signal acc_muxS :   std_logic := '0';

    signal bkp_en   :   std_logic := '0';

    signal pc_ow    :   std_logic := '0';
    signal pc_inc   :   std_logic := '0';

    signal mem_en   :   std_logic := '0';

    signal scr_en   :   std_logic := '0';
    signal dest_en  :   std_logic := '0';

    --secondary control pins
    signal acc_flgs :   std_logic_vector(3 downto 0);
    signal scr_ctrl :   std_logic_vector(6-1 downto 0); --TODO: maybe put the value in a config
    signal dest_ctrl:   std_logic_vector(6-1 downto 0); --TODO: maybe put the value in a config

    --wires
    signal alu_a    :   signed(DATA_BITS-1 downto 0);
    signal alu_b    :   signed(DATA_BITS-1 downto 0);
    signal alu_o    :   signed(DATA_BITS-1 downto 0);
    
    signal bus_data :   signed(DATA_BITS-1 downto 0);

    signal acc_in   :   signed(DATA_BITS-1 downto 0);
    
    signal bkp_o    :   signed(DATA_BITS-1 downto 0);
    
    signal pc_addr  :   unsigned(ADDRESS_BITS-1 downto 0);
    signal pc_addrIn:   unsigned(ADDRESS_BITS-1 downto 0);
    
    signal mem_o    :   std_logic_vector(MEM_BITS-1 downto 0);

    begin

        --Program Counter
        PC: entity work.PC(arch)
            generic map (ADDRESS_BITS => ADDRESS_BITS)
            port map(
                clk         =>  clk,
                i_address   =>  pc_addrIn,
                i_IncEn     =>  pc_inc,
                i_OwEn      =>  pc_ow,
                o_address   =>  pc_addr
            );

        --Instruction memory
        MEM: entity work.MEM(arch)
            generic map(
                ADDR_BITS   =>  ADDRESS_BITS,
                DATA_LINES  =>  15,
                MEM_BITS    =>  MEM_BITS
            )
            port map(
                i_address   =>  pc_addr,
                o_data      =>  mem_o
            );

        SCR_ADDR_DEC: entity work.ADDR_DEC(arch)
            generic map(
                ADDRESS_BITS=>  3,
                OUTPUTS_N   =>  6
            )
            port map(
                clk         =>  clk,
                i_address   =>  mem_o(5 downto 3),
                i_OutEn     =>  scr_en,
                o_control   =>  scr_ctrl
            );

        DES_ADDR_DEC: entity work.ADDR_DEC(arch)
        generic map(
            ADDRESS_BITS=>  3,
            OUTPUTS_N   =>  6
        )
        port map(
            clk         =>  clk,
            i_address   =>  mem_o(2 downto 0),
            i_OutEn     =>  dest_en,
            o_control   =>  dest_ctrl
        );

        --Arithmetic-Logic Unit
        ALU: entity work.ALU(arch)
            generic map (DATA_BITS => DATA_BITS)
            port map (
                i_a     =>  bus_data, --TODO add mux
                i_b     =>  alu_b,
                i_op    =>  alu_op,
                o_out   =>  alu_o
            );
        
        acc_mux: process(all) begin
            acc_in <= alu_o when acc_muxS = '1' else bkp_o;
        end process;
        
        --Accumulator register
        ACC: entity work.ACC(arch)
            generic map (DATA_BITS => DATA_BITS)
            port map (
                clk       =>  clk,  
                i_dataIn  =>  acc_in,
                i_inEn    =>  acc_inEn,
                i_outEn   =>  acc_outEn,
                o_dataOut =>  bus_data,
                o_flags   =>  acc_flgs
            );

        --Backup register
        BKP: entity work.BKP(arch)
            generic map (DATA_BITS => DATA_BITS)
            port map(
                clk       =>  clk, 
                i_dataIn  =>  bus_data,
                i_En      =>  bkp_en,
                o_dataOut =>  bkp_o
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
            acc_muxS    <=  '1';
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
            acc_muxS <= '0';
            bkp_en   <= '1';
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