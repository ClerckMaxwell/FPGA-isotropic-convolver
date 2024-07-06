library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO_NORMAL is
    generic ( DIM_FIFO_N : integer);
Port(clk,rst,D_in : in std_logic;
D_out: out std_logic);
end FIFO_NORMAL;

architecture Behavioral of FIFO_NORMAL is

component R_E_G is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end component;

signal internals: std_logic_vector(DIM_FIFO_N downto 0);

begin

internals(0)<=D_in;

GEN: for i in 0 to DIM_FIFO_N-1 generate
F_i: R_E_G port map(internals(i),clk,rst,internals(i+1));
end generate;

D_out<=internals(DIM_FIFO_N);

end Behavioral;
