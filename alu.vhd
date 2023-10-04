library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ALU is
    port
    (
        inputA: in  STD_LOGIC_VECTOR(31 downto 0);
        inputB: in  STD_LOGIC_VECTOR(31 downto 0);
        ctrl:   in  STD_LOGIC_VECTOR(2 downto 0);
        result: out STD_LOGIC_VECTOR(31 downto 0);
    );
end ALU;

architecture behavior of ALU is
    
begin


process(ctrl) begin
    case ctrl is
        when  "000" =>
            result <= inputA and inputB;
        when  "001" =>
            result <= inputA or inputB;
        when  "010" =>
            result <= std_logic_vector(to_signed(inputA) + to_signed(inputB));
        when  "110" =>
            result <= std_logic_vector(to_signed(inputA) - to_signed(inputB));        
        when  "111" =>
            result <= std_logic_vector(to_signed(inputA) < to_signed(inputB));
        others =>
            result = "--------------------------------";
    end case;
end process;