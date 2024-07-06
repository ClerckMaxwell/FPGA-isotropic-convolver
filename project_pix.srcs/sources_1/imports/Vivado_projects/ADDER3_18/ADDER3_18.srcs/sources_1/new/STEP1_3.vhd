library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity STEP1_3 is
Port (clk, rst: in std_logic;
      op1,op2,op3:in std_logic_vector(17 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(18 DOWNTO 0) 
      );
end STEP1_3;

architecture Behavioral of STEP1_3 is
signal sp_int, vr_int, op4_int: std_logic_vector(18 downto 0);

 component FA is     
  Port (op1,op2,op3:in std_logic;
        SP,VR:OUT STD_LOGIC);
 end component;

begin


 FA_f: for i in 0 to 17 generate
 FA_i: FA port map (op1(i), op2(i), op3(i), sp_int(i), vr_int(i+1));
 end generate;
 
 sp_int(18) <= sp_int(17);
 vr_int(0) <= '0';
 
 process(clk,rst)
 begin
  if rst = '1' then
   SP <= (others => '0');
   VR <= (others => '0');
  elsif rising_edge(clk) then
   SP <= sp_int;
   VR <= vr_int;
  end if;
 end process;
 
end Behavioral;
