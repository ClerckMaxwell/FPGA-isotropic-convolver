library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
 Port (op1,op2,op3:in std_logic;
       SP,VR:OUT STD_LOGIC);
end FA;

architecture Behavioral of FA is
 signal p,g,S,R: std_logic;
begin

    p<= op1 xor op2;
    g<= p and op2;
    SP<=p xor op3;
    VR<=(p AND op3) OR (op1 and op2);

end Behavioral;
