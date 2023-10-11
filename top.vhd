library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.ALL;


entity top is -- top-level design for testing
port (clk, reset: in STD_LOGIC;
writedata, dataadr: buffer STD_LOGIC_VECTOR (31 downto 0);
memwrite: buffer STD_LOGIC);
end;


architecture test of top is

component mips is -- single cycle MIPS processor
port (clk, reset: in STD_LOGIC;
pcout: buffer STD_LOGIC_VECTOR (31 downto 0);
instr: in STD_LOGIC_VECTOR (31 downto 0);
memwrite: out STD_LOGIC;
aluout, writedata: out STD_LOGIC_VECTOR (31 downto 0);
readdata: in STD_LOGIC_VECTOR (31 downto 0));
end component;

component imem is
    Port ( a : in  STD_LOGIC_VECTOR (5 downto 0);
           rd : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component dmem is -- data memory
port (clk, we: in STD_LOGIC;
a, wd: in STD_LOGIC_VECTOR (31 downto 0);
rd: out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal pcout, instr, readdata: STD_LOGIC_VECTOR (31 downto 0);

begin

-- instantiate processor and memories
mips1: mips 
port map (clk=>clk, reset=>reset, pcout=>pcout, instr=>instr, memwrite=>memwrite, writedata=>writedata, readdata=>readdata);

imem1: imem 
port map (a=>pcout (7 downto 2), rd=>instr);

dmem1: dmem 
port map (clk=>clk, we=>memwrite, a=>dataadr, wd=>writedata, rd=>readdata);


end;