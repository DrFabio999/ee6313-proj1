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
signal reg_clk: std_logic_vector(31 downto 0) := (others=>'L');


begin

writeAddr <= to_integer(unsigned(A3));
readAddr1 <= to_integer(unsigned(A1));
readAddr2 <= to_integer(unsigned(A2));

--reg_clk <= selW1 and (others=>clk);

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
	reg_clk(i) <= selW1(i) and clk;
	regs0: regis port map(clk =>reg_clk(i),rst=>'1',d_in=>WD3(7 downto 0),d_out=>dataB0(i));
	regs1: regis port map(clk =>reg_clk(i),rst=>'1',d_in=>WD3(15 downto 8),d_out=>dataB1(i));
	regs2: regis port map(clk =>reg_clk(i),rst=>'1',d_in=>WD3(23 downto 16),d_out=>dataB2(i));
	regs3: regis port map(clk =>reg_clk(i),rst=>'1',d_in=>WD3(31 downto 24),d_out=>dataB3(i));
	
end generate;




RD1 <= std_logic_vector((resize(unsigned(dataB3(readAddr1)),32) sll 24) or (resize(unsigned(dataB2(readAddr1)),32) sll 16) or (resize(unsigned(dataB1(readAddr1)),32) sll 8) or resize(unsigned(dataB0(readAddr1)),32));
RD2 <= std_logic_vector((resize(unsigned(dataB3(readAddr2)),32) sll 24) or (resize(unsigned(dataB2(readAddr2)),32) sll 16) or (resize(unsigned(dataB1(readAddr2)),32) sll 8) or resize(unsigned(dataB0(readAddr2)),32));

end architecture;