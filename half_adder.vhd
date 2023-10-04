library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity half_adder is
    port
    (
        inA: in std_logic
        inB: in std_logic
        result: out std_logic
        carry: out std_logic
    );
end half_adder;

architecture behavior of half_adder is
    
begin

result <= inA xor inB;
carry <= inA and inB;

end;