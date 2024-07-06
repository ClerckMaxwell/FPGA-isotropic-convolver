library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity TOP_MULTI is
port(b: in std_logic_vector(7 downto 0);--- b sono i coefficienti del filtro che sono signed !
a: in std_logic_vector(9 downto 0);
clk,reset: in std_logic;
P_out: out std_logic_vector(17 downto 0) 
);
end TOP_MULTI;

architecture Behavioral of TOP_MULTI is

component CARRY_SAVE is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3,OP4:IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      FINAL_RIS:OUT STD_LOGIC_VECTOR(20 DOWNTO 0));
end component;

component Partial_products is
Port( a: in std_logic_vector(9 downto 0);
exa, da, mda, ma: out std_logic_vector(11 downto 0);
clk,rst: in std_logic);
end component;

component MUX is
Port(exa, da, ma, mda: in std_logic_vector(11 downto 0);
enc: in std_logic_vector(2 downto 0);
clk,rst: in std_logic;
p : out std_logic_vector(11 downto 0));
end component;

component booth is
    Port (clk, rst: in std_logic;
          b0, b1, b2: in std_logic;
          enc: out std_logic_vector(2 downto 0));
end component;

signal enc_int: std_logic_vector(11 downto 0);
signal exa_int, da_int, mda_int, ma_int: std_logic_vector(11 downto 0);
signal mux_out: std_logic_vector(47 downto 0);
signal P_temp: std_logic_vector(20 downto 0);

begin

booth_enc_0: booth port map(clk,reset,'0',b(0),b(1),enc_int(2 downto 0));

gen: for i in 0 to 2 generate
booth_enc_i: booth port map(clk,reset,b(2*i+1),b(2*i+2),b(2*i+3),enc_int(3*i+5 downto 3*i+3));
end generate;

pp: partial_products port map(a, exa_int, da_int, mda_int, ma_int, clk, reset);

gen2: for j in 0 to 3 generate
MUX_i: MUX port map(exa_int, da_int, ma_int, mda_int,enc_int(3*j+2 downto 3*j), clk, reset, mux_out(12*j+11 downto 12*j ));
end generate;

ADDER_TREE: CARRY_SAVE port map (clk, reset, mux_out(47 downto 36),mux_out(35 downto 24),mux_out(23 downto 12),mux_out(11 downto 0),P_temp);

P_out<=P_temp(17 downto 0);

end Behavioral;
