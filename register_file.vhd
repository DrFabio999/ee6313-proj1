library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity register_file is
    port
    (
        A1: in std_logic_vector(4 downto 0);
        A2: in std_logic_vector(4 downto 0);
        A3: in std_logic_vector(4 downto 0);
        clk: in std_logic;
        WE3: in std_logic;
		  reset: in std_logic;
        WD3: in std_logic_vector(31 downto 0);
        RD1: out std_logic_vector(31 downto 0);
        RD2: out std_logic_vector(31 downto 0)
    );
end entity register_file;

architecture behavior of register_file is

component regis is
    port
    (
        clk: in std_logic;
        rst: in std_logic;
        d_in: in std_logic_vector(7 downto 0); -- input1
        d_out: out std_logic_vector(7 downto 0) -- output, 1 bit wider    
    );
end component regis;

type std_logic_array_of_vector is array(natural range<>) of std_logic_vector(7 downto 0);
signal selR1: std_logic_vector(31 downto 0) := (others=>'0');
signal selR2: std_logic_vector(31 downto 0) := (others=>'0');
signal selW1: std_logic_vector(31 downto 0) := (others=>'0');
signal dataB0: std_logic_array_of_vector(0 to 31) := (others => (others => 'L'));
signal dataB1: std_logic_array_of_vector(0 to 31) := (others => (others => 'L'));
signal dataB2: std_logic_array_of_vector(0 to 31) := (others => (others => 'L'));
signal dataB3: std_logic_array_of_vector(0 to 31) := (others => (others => 'L'));
signal writeAddr: integer := 0;
signal readAddr1: integer := 0;
signal readAddr2: integer := 0;
signal reg_clk: std_logic := '0';
signal res: std_logic;
signal d_buffer: std_logic_vector(31 downto 0) := (others=>'0');
signal reg_anticlk: std_logic_vector(31 downto 0) := (others=>'0');
constant clk_period : time := 10 ns;

begin

writeAddr <= to_integer(unsigned(A3));
readAddr1 <= to_integer(unsigned(A1));
readAddr2 <= to_integer(unsigned(A2));
res <= not reset;

sel_generation: for i in 31 downto 0 generate
	process(writeAddr,WE3,selW1) begin
    first_if: if writeAddr = i then
		second_if: if WE3 = '1' then
							selW1(i) <= '1';
					  else
							selW1(i) <= '0';
					end if;
                else
                    selW1(i) <= '0';
                end if;
	end process;
end generate;

regs_gen: for i in 31 downto 0 generate
	reg_anticlk(i) <= selW1(i) and not clk;
	regs0: regis port map(clk =>reg_anticlk(i),rst=>res,d_in=>WD3(7 downto 0),d_out=>dataB0(i)); --32x(4x1byte regs) - 32x 32bit regs
	regs1: regis port map(clk =>reg_anticlk(i),rst=>res,d_in=>WD3(15 downto 8),d_out=>dataB1(i));
	regs2: regis port map(clk =>reg_anticlk(i),rst=>res,d_in=>WD3(23 downto 16),d_out=>dataB2(i));
	regs3: regis port map(clk =>reg_anticlk(i),rst=>res,d_in=>WD3(31 downto 24),d_out=>dataB3(i));
	
end generate;

buff0: regis port map(clk =>clk,rst=>res,d_in=>WD3(7 downto 0),d_out=>d_buffer(7 downto 0));
buff1: regis port map(clk =>clk,rst=>res,d_in=>WD3(15 downto 8),d_out=>d_buffer(15 downto 8));
buff2: regis port map(clk =>clk,rst=>res,d_in=>WD3(23 downto 16),d_out=>d_buffer(23 downto 16));
buff3: regis port map(clk =>clk,rst=>res,d_in=>WD3(31 downto 24),d_out=>d_buffer(31 downto 24));


--correctly aligning data bytes
RD1 <= std_logic_vector((resize(signed(dataB3(readAddr1)),32) sll 24) or (resize(signed(dataB2(readAddr1)),32) sll 16) or (resize(signed(dataB1(readAddr1)),32) sll 8) or resize(signed(dataB0(readAddr1)),32));
RD2 <= std_logic_vector((resize(signed(dataB3(readAddr2)),32) sll 24) or (resize(signed(dataB2(readAddr2)),32) sll 16) or (resize(signed(dataB1(readAddr2)),32) sll 8) or resize(signed(dataB0(readAddr2)),32));

end architecture;