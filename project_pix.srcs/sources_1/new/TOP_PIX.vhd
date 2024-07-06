
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TOP_PIX is
port(pixels: in std_logic_vector(71 downto 0);
wc,wl,w: in std_logic_vector(7 downto 0);
clk,rst: in std_logic;
pix_out: out std_logic_vector(7 downto 0));
end TOP_PIX;

architecture Behavioral of TOP_PIX is

component CARRY_SAVE4_8 is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3,OP4:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      pix_to_delay: in std_logic_vector(7 downto 0);
      FINAL_RIS, central_pix:OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
end component;

component CARRY_SAVE_3 is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3:IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      FINAL_RIS:OUT STD_LOGIC_VECTOR(19 DOWNTO 0));
end component;

component TOP_MULTI is
port(b: in std_logic_vector(7 downto 0);--- b sono i coefficienti del filtro che sono signed !
a: in std_logic_vector(9 downto 0);
clk,reset: in std_logic;
P_out: out std_logic_vector(17 downto 0) 
);
end component;

component SATURATION is
Port( clk,rst: in std_logic;
pix_in: in std_logic_vector(19 downto 0);
pix_sat: out std_logic_vector(7 downto 0));
end component;

signal to_last_sum: std_logic_vector(53 downto 0);
signal to_multi: std_logic_vector(19 downto 0);
signal central: std_logic_vector(9 downto 0);
signal garbage: std_logic_vector(9 downto 0);
signal pixel_temp: std_logic_vector(19 downto 0);

begin


TO_SUM_WC: CARRY_SAVE4_8 port map(clk,rst,pixels(7 downto 0),pixels(23 downto 16),pixels(55 downto 48),pixels(71 downto 64),pixels(39 downto 32),to_multi(9 downto 0),central);
TO_SUM_WL: CARRY_SAVE4_8 port map(clk,rst,pixels(15 downto 8),pixels(31 downto 24),pixels(47 downto 40), pixels(63 downto 56),"00000000",to_multi(19 downto 10),garbage);
TO_MULTI_WC: TOP_MULTI port map(wc,to_multi(9 downto 0),clk,rst,to_last_sum(17 downto 0));
TO_PROD_WL: TOP_MULTI port map(wl,to_multi(19 downto 10),clk,rst,to_last_sum(35 downto 18));
TO_PROD_W: TOP_MULTI port map(w,central,clk,rst,to_last_sum(53 downto 36));
LAST_ADD: CARRY_SAVE_3 port map(clk,rst,to_last_sum(17 downto 0),to_last_sum(35 downto 18),to_last_sum(53 downto 36),pixel_temp);
TO_SAT: SATURATION port map (clk, rst,pixel_temp,pix_out);

end Behavioral;
