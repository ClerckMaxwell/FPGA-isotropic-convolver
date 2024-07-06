library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FIFO8_NORMAL is
    generic ( DIM_FIFO_N : integer);
Port(clk,rst: std_logic;
D_in : in std_logic_vector(7 downto 0);
D_out: out std_logic_vector(7 downto 0));
end FIFO8_NORMAL;

architecture Behavioral of FIFO8_NORMAL is

component REG8 is
Port (Din: in std_logic_vector(7 downto 0);
clk, rst: in std_logic;
Q: out std_logic_vector (7 downto 0)
);
end component;

signal internals: std_logic_vector(DIM_FIFO_N*8+7 downto 0);

begin

internals(7 downto 0)<=D_in;

GEN: for i in 0 to DIM_FIFO_N-1 generate
F_i: REG8 port map(internals(8*i+7 downto 8*i),clk,rst,internals(8*(i+1)+7 downto 8*(i+1)));
end generate;

D_out<=internals(8*DIM_FIFO_N+7 downto 8*DIM_FIFO_N);


end Behavioral;
