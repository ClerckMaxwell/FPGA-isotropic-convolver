library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity booth is
    Port (clk, rst: in std_logic;
          b0, b1, b2: in std_logic;
          enc: out std_logic_vector(2 downto 0));
end booth;

architecture Behavioral of booth is

    signal a_int, b_int, c_int, b0_p, b1_p, b2_p: std_logic;
    signal enc_int: std_logic_vector(2 downto 0);
    
  begin
    a_int <= b0_p xor b1_p;
    b_int <= b1_p xor b2_p;
    c_int <= b1_p nand b0_p;
    enc_int(0) <= a_int;
    enc_int(1) <= (not a_int) and b_int;
    enc_int(2) <= c_int and b2_p;
    
    process(clk,rst)
    begin
        if rst='1' then
         enc <= (others => '0');
         b0_p <= '0';
         b1_p <= '0';
         b2_p <= '0';
        elsif rising_edge(clk) then
         b0_p <= b0;
         b1_p <= b1;
         b2_p <= b2;
         enc <= enc_int;
        end if;
    end process;


end Behavioral;
