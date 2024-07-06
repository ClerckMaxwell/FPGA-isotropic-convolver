
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity MUX is
Port(exa, da, ma, mda: in std_logic_vector(11 downto 0);
enc: in std_logic_vector(2 downto 0);
clk,rst: in std_logic;
p : out std_logic_vector(11 downto 0));
end MUX;

architecture Behavioral of MUX is
signal p_p : std_logic_vector(11 downto 0);

begin

with enc select
p_p<= exa when "001",
    da when "010",
    ma when "101",
    mda when "110",
    (others=>'0') when others;
    
    process(clk, rst)
    begin
    if rst = '1' then
    p<= (others=>'0');
    elsif(rising_edge(clk)) then
    p<= p_p;
    end if;
    end process;
end Behavioral;
