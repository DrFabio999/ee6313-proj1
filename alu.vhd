library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity ALU is
    port
    (
        inputA: in  STD_LOGIC_VECTOR(31 downto 0);
        inputB: in  STD_LOGIC_VECTOR(31 downto 0);
        ctrl:   in  STD_LOGIC_VECTOR(2 downto 0);
        result: buffer STD_LOGIC_VECTOR(31 downto 0);
		  zero: out std_logic
    );
end ALU;

architecture behavior of ALU is
    
begin


process(ctrl,inputA,inputB,result) begin
    case ctrl is
        when  "000" => --and op
            result <= std_logic_vector(signed(inputA) and signed(inputB));
				zero <= '0';
        when  "001" => --or op
            result <= std_logic_vector(signed(inputA) or signed(inputB));
				zero <= '0';
        when  "010" => --+ op
            result <= std_logic_vector(signed(inputA) + signed(inputB));
				zero <= '0';
        when  "110" => --- op
            result <= std_logic_vector(signed(inputA) - signed(inputB));
				if result = "00000000000000000000000000000000" then
					zero <= '1';
				else
					zero <= '0';
				end if;
        when  "111" => --slt op
            if signed(inputA) < signed(inputB) then
					result <= "00000000000000000000000000000001";
				else
					result <= "00000000000000000000000000000000";
				end if;
				zero <= '0';
        when others =>
            result <= (others =>'-');
				zero <= '0';
    end case;
end process;

end;