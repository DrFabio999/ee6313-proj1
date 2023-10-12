library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity regis is
port(
clk: in std_logic;
rst: in std_logic;
d_in: in std_logic_vector(7 downto 0); -- input1
d_out: out std_logic_vector(7 downto 0)); attribute noprune: boolean; attribute noprune of d_out: signal is true; -- output, 1 bit wider
end regis;
architecture arch1 of regis is
signal d_R: std_logic_vector(7 downto 0) := (others=>'L'); attribute noprune of d_R: signal is true;-- output register
begin
process(clk, rst)
begin
if rst = '0' then
d_R <= (others => '0');
elsif rising_edge(clk) then
d_R <= d_in;
end if;
end process;
d_out <= d_R;
end arch1;