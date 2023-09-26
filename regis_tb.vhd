library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity regis_tb is
end regis_tb;
architecture regis_arch_tb of regis_tb is
signal clk: std_logic := '0';
signal rst: std_logic := '0';
signal d_in: std_logic_vector(7 downto 0) := (others=>'0');
signal d_out: std_logic_vector(7 downto 0) := (others=>'0');
constant clk_period : time := 10 ns;
component regis is
port(
clk: in std_logic;
rst: in std_logic;
d_in: in std_logic_vector(7 downto 0); -- input1
d_out: out std_logic_vector(7 downto 0)); -- output, 1 bit wider
end component;
begin
dut: regis port map(
clk => clk,
rst => rst,
d_in => d_in,
d_out => d_out);
clk_process :process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;
stim_process:process
begin
wait for 1 ns;
rst <= '1';
wait for 27 ns;
d_in <= "00001111";
wait;
end process;
end regis_arch_tb;