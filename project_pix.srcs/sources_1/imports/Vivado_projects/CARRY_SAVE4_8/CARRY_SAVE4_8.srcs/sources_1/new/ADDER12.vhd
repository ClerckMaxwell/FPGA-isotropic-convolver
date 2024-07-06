library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity ADDER12 is 
port ( A,B : in std_logic_vector (11 downto 0); 
Cin : in std_logic; 
Sum : out std_logic_vector (12 downto 0)); 
end ADDER12; 

architecture CSA of ADDER12 is 
signal C_int : std_logic_vector(3 downto 0); 

component RCA_4bit is 
port(a,b : in std_logic_vector (3 downto 0); 
Cin : in std_logic; 
Sic : out std_logic_vector (3 downto 0); 
Cout: out std_logic); 
end component;

begin

C_int(0) <= Cin;

FOR_GEN: for i in 0 to 2 generate
   RCA4: RCA_4bit port map (A(3+4*i downto 4*i), B(3+4*i downto 4*i), C_int(i), Sum(3+4*i downto 4*i), C_int(i+1));
end generate;

Sum(12)<= C_int(3); 

end CSA;