library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity top_tb is
end top_tb;
architecture tb_arch_top of top_tb is
signal clk: std_logic := '0';
signal reset: std_logic := '0';
signal writedata: std_logic_vector(31 downto 0) := (others=>'0');
signal dataadr: std_logic_vector(31 downto 0) := (others=>'0');
signal memwrite: std_logic := '0';
constant clk_period : time := 10 ns;
component top is -- top-level design for testing
    port (clk, reset: in STD_LOGIC;
    writedata, dataadr: buffer STD_LOGIC_VECTOR (31 downto 0);
    memwrite: buffer STD_LOGIC);
end component;
begin
dut: top port map(
clk => clk,
reset => reset,
writedata => writedata,
dataadr => dataadr,
memwrite => memwrite);
clk_process :process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1';
wait for clk_period/2;
end process;

end tb_arch_top;