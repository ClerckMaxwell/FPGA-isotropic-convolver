library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity TOP_BUF is
Port (pixel_in: in std_logic_vector(7 downto 0);
clk,rst: in std_logic;
pixel_out: out std_logic_vector(71 downto 0)
);
end TOP_BUF;

architecture Behavioral of TOP_BUF is

signal Qinternal: std_logic_vector(535 downto 0);
signal pix_p: std_logic_vector(7 downto 0);

component REG8 is
Port (Din: in std_logic_vector(7 downto 0);
clk, rst: in std_logic;
Q: out std_logic_vector (7 downto 0)
 );
end component;

begin

pix_p<=pixel_in;
pixel_out(7 downto 0)<=Qinternal(7 downto 0);
pixel_out(15 downto 8)<=Qinternal(15 downto 8);
pixel_out(23 downto 16)<=Qinternal(23 downto 16);
pixel_out(31 downto 24)<=Qinternal(263 downto 256);
pixel_out(39 downto 32)<=Qinternal(271 downto 264);
pixel_out(47 downto 40)<=Qinternal(279 downto 272);
pixel_out(55 downto 48)<=Qinternal(519 downto 512);
pixel_out(63 downto 56)<=Qinternal(527 downto 520);
pixel_out(71 downto 64)<=Qinternal(535 downto 528);

REG8_0: REG8 port map(pix_p,clk,rst,Qinternal(7 downto 0));
FIFO: for i in 1 to 66 generate
REG8_i: REG8 port map (Qinternal(8*i-1 downto 8*(i-1)),clk,rst,Qinternal(8*(i+1)-1 downto 8*i));
end generate;

--pixel_out1<=Qinternal(7 downto 0);
--pixel_out2<=Qinternal(15 downto 8);
--pixel_out3<=Qinternal(23 downto 16);
--pixel_out4<=Qinternal(263 downto 256);
--pixel_out5<=Qinternal(271 downto 264);
--pixel_out6<=Qinternal(279 downto 272);
--pixel_out7<=Qinternal(519 downto 512);
--pixel_out8<=Qinternal(527 downto 520);
--pixel_out9<=Qinternal(535 downto 528);


end Behavioral;