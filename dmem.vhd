library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dmem is
port (clk, we: in STD_LOGIC;
a, wd: in STD_LOGIC_VECTOR (31 downto 0);
rd: out STD_LOGIC_VECTOR (31 downto 0));
end;


architecture synth2 of dmem is

type mem_array is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
signal mem: mem_array; 

begin

process (clk,wd,a,we)
begin
if clk'event and clk = '1' then 
	if we = '1' then
    	mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
	end if;
end if;
end process;

rd <= mem(to_integer(unsigned(a(7 downto 2))));

end synth2;