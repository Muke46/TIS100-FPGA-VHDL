--! Source address decoder
--! Gets in input the address and has a control pin for each register
--! Stores internally the last used register, if the address of LAST is given, the value in the memory is used
--! If the address of ANY is given, activates all ports
--! 
--! Reserved addresses:
--! 110 -> LAST
--! 111 -> ANY
--! 
--! Note: verify if the result of ANY update LAST, this will complicate things a bit

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity SRC_ADDR_DEC is
    generic(
        ADDRESS_BITS  : integer := 3;
        OUTPUTS_N     : integer := 6
    );

    port(
        clk         : in  std_logic;
        i_address   : in  unsigned(ADDRESS_BITS-1 downto 0);
        i_OutEn     : in  std_logic;
        o_control   : out unsigned(OUTPUTS_N-1 downto 0) := (others => '0')
    );

end SRC_ADDR_DEC;

architecture arch of SRC_ADDR_DEC is
    signal address  : unsigned(ADDRESS_BITS-1 downto 0) := (others => '0');
    signal last     : unsigned(ADDRESS_BITS-1 downto 0) := (others => '0');
    begin
        process(clk)
            begin
                if falling_edge(clk) then --TODO add OutEn
                    if i_OutEn = '1' then
                        if i_address = "110" then
                            address <= last;
                        else
                            last <= i_address;
                            address <= i_address;
                        end if;
                    end if;
                end if;
        end process;

        process(all)
            begin  --TODO add OutEn
                if i_OutEn = '1' then
                    case address is
                        when "000" => -- UP
                            o_control <= "000001";
                        when "001" => -- DOWN
                            o_control <= "000010";
                        when "010" => -- LEFT
                            o_control <= "000100";
                        when "011" => -- RIGHT
                            o_control <= "001000";
                        when "100" => -- ACC
                            o_control <= "010000";
                        when "101" => -- ZERO
                            o_control <= "100000";
                        when "111" => -- ANY
                            o_control <= "001111";
                        when others =>
                            o_control <= (others => '0');
                    end case;
                else
                    o_control <= (others => '0');
                end if;
        end process;
    end arch;