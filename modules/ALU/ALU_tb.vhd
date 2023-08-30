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
    
    component ALU is
        port(
        i_a        : in  signed(DATA_BITS-1 downto 0);
        i_b        : in  signed(DATA_BITS-1 downto 0);
        i_op       : in  std_logic_vector(1 downto 0);
        o_out      : out signed(DATA_BITS-1 downto 0)
    );
    end component;

    signal a, b, out_s : signed(DATA_BITS-1 downto 0):= (others => '0');
    signal i_op : signed(1 downto 0):= (others => '0');

    begin
        DUT: ALU port map(a, b, i_op, out_s);

        process
        begin
            -- ADD test
            report "Starting ADD test" severity note;
            i_op    <= "00";
            a       <= to_signed(10,11);
            b       <= to_signed(10,11);
            wait for 1 ns;
            assert out_s = to_signed(20,11) report "ADD 0 ERROR" severity note;

            a       <= to_signed(100,11);
            b       <= to_signed(-10,11);
            wait for 1 ns;
            assert out_s = to_signed(90,11) report "ADD 1 ERROR" severity note;

            a       <= to_signed(-999,11);
            b       <= to_signed(501,11);
            wait for 1 ns;
            assert out_s = to_signed(-498,11) report "ADD 2 ERROR" severity note;

            a       <= to_signed(-999,11);
            b       <= to_signed(1509,11);
            wait for 1 ns;
            assert out_s = to_signed(510,11) report "ADD 3 ERROR" severity note;

            -- SUB test
            report "Starting SUB test" severity note;
            i_op    <= "01";
            a       <= to_signed(10,11);
            b       <= to_signed(10,11);
            wait for 1 ns;
            assert out_s = to_signed(0,11) report "SUB 0 ERROR" severity note;

            a       <= to_signed(100,11);
            b       <= to_signed(-10,11);
            wait for 1 ns;
            assert out_s = to_signed(110,11) report "SUB 1 ERROR" severity note;

            a       <= to_signed(999,11);
            b       <= to_signed(501,11);
            wait for 1 ns;
            assert out_s = to_signed(498,11) report "SUB 2 ERROR" severity note;

            a       <= to_signed(-999,11);
            b       <= to_signed(-1509,11);
            wait for 1 ns;
            assert out_s = to_signed(510,11) report "SUB 3 ERROR" severity note;

            -- SUB test
            report "Starting NEG test" severity note;
            i_op    <= "10";
            a       <= to_signed(10,11);
            wait for 1 ns;
            assert out_s = to_signed(-10,11) report "NEG 0 ERROR" severity note;

            a       <= to_signed(100,11);
            wait for 1 ns;
            assert out_s = to_signed(-100,11) report "NEG 1 ERROR" severity note;

            a       <= to_signed(999,11);
            wait for 1 ns;
            assert out_s = to_signed(-999,11) report "NEG 2 ERROR" severity note;

            a       <= to_signed(0,11);
            wait for 1 ns;
            assert out_s = to_signed(0,11) report "NEG 3 ERROR" severity note;

            -- B test
            report "Starting B test" severity note;
            i_op    <= "11";
            b       <= to_signed(10,11);
            wait for 1 ns;
            assert out_s = to_signed(10,11) report "B 0 ERROR" severity note;

            b       <= to_signed(100,11);
            wait for 1 ns;
            assert out_s = to_signed(100,11) report "B 1 ERROR" severity note;

            b       <= to_signed(999,11);
            wait for 1 ns;
            assert out_s = to_signed(999,11) report "B 2 ERROR" severity note;

            b       <= to_signed(0,11);
            wait for 1 ns;
            assert out_s = to_signed(0,11) report "B 3 ERROR" severity note;

            --address <= (others => '0');

            --for i in 0 to DATA_LINES-1 loop

                wait for 1 ns;
                --address <= "0001";
            --    address <= to_unsigned(i, 4));
                --address <= to_unsigned(address, address'length) + to_unsigned(1,1));

            --end loop;

            assert false report "Test done." severity note;
            wait;
        end process;

    end architecture;