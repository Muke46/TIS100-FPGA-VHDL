--! ALU module
--! 2 inputs
--! 1 output
--! 4 operations: ADD, SUB, NEG, B (maybe not needed?)

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ALU is
    generic(
        DATA_BITS  : integer := 11
    );

    port(
        i_a        : in  signed(DATA_BITS-1 downto 0);
        i_b        : in  signed(DATA_BITS-1 downto 0);
        i_op       : in  std_logic_vector(1 downto 0);
        o_out      : out signed(DATA_BITS-1 downto 0)
    );
end ALU;

architecture arch of ALU is

    begin
        process(all)
            begin
                case i_op is
                    when "00" => --ADD
                        o_out <= signed(i_a) + signed(i_b);
                    when "01" => --SUB
                        o_out <= signed(i_a) - signed(i_b);
                    when "10" => 
                        o_out <= to_signed(0,11) - signed(i_a); --thre is probably a better way
                    when "11" =>
                        o_out <= i_b;
                    when others =>
                        o_out <= (others => '0');
                end case;
        end process;
    end arch;