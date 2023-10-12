library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity mips is
    port
    (
        clk: in std_logic;
        reset: in std_logic;
        pcout: buffer std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0);
        memwrite: out std_logic;
        aluout: out std_logic_vector(31 downto 0);
        writedata: out std_logic_vector(31 downto 0);
        readdata: in std_logic_vector(31 downto 0)
    );
end entity mips;

architecture behavior of mips is

component register_file
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
end component register_file;

component alu
    port
    (
        inputA: in  STD_LOGIC_VECTOR(31 downto 0);
        inputB: in  STD_LOGIC_VECTOR(31 downto 0);
        ctrl:   in  STD_LOGIC_VECTOR(2 downto 0);
        result: buffer STD_LOGIC_VECTOR(31 downto 0);
		  zero: out std_logic
    );
end component alu;

component controller
  port
  (
		op: in std_logic_vector(5 downto 0);
		funct: in std_logic_vector(5 downto 0);
		zero: in std_logic;
		memtoreg: out std_logic;
		memwrite: out std_logic;
		pcsrc: out std_logic;
		alusrc: out std_logic;
		regdst: out std_logic;
		regwrite: out std_logic;
		jump: out std_logic;
		alucontrol: out std_logic_vector(2 downto 0)
  );
end component controller;

component pc is
    port
    (
        clk: in std_logic;
        PCsrc: in std_logic;
        jump: in std_logic;
        immed: in std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0);
        pcout: out std_logic_vector(31 downto 0)
    );
end component pc;

signal memtoreg: std_logic := '0';
signal memtowrite: std_logic := '0';
signal pcsrc: std_logic := '0';
signal alusrc: std_logic := '0';
signal regdst: std_logic := '0';
signal regwrite: std_logic := '0';
signal jump: std_logic := '0';
signal aluctl: std_logic_vector(2 downto 0) := (others=>'0');
signal zero: std_logic := '0';

signal aluInputB: std_logic_vector(31 downto 0) := (others=>'0');
signal A3: std_logic_vector(4 downto 0) := (others=>'0');
signal RD1: std_logic_vector(31 downto 0) := (others=>'L');
signal RD2: std_logic_vector(31 downto 0) := (others=>'L');
signal result: std_logic_vector(31 downto 0) := (others=>'L');
signal alures: std_logic_vector(31 downto 0) := (others=>'0');

signal signImm: std_logic_vector(31 downto 0) := (others=>'0');

signal PCplus4: std_logic_vector(31 downto 0) := (others=>'0');

signal instruction: std_logic_vector(31 downto 0) := (others=>'0');

begin

controller1: controller port map(op=>instruction(31 downto 26), funct=>instruction(5 downto 0),zero=>zero,
                    memtoreg=>memtoreg,memwrite=>memtowrite,pcsrc=>pcsrc,
                    alusrc=>alusrc,regdst=>regdst,regwrite=>regwrite,jump=>jump,
                    alucontrol=>aluctl);

alu1: alu port map(inputA=>RD1,inputB=>aluInputB,ctrl=>aluctl,result=>alures,zero=>zero);
register_file1: register_file port map(A1=>instruction(25 downto 21),A2=>instruction(20 downto 16),A3=>A3,clk=>clk,WE3=>regwrite,WD3=>result,RD1=>RD1,RD2=>RD2);
pc1: pc port map(clk=>clk,PCsrc=>pcsrc,jump=>jump,immed=>signImm,instr=>instruction,pcout=>pcout);

process (regdst,instruction) begin
if regdst = '0' then
    A3 <= instruction(20 downto 16);
else
    A3 <= instruction(15 downto 11);
end if;
end process;

instruction <= instr;
--writedata <= RD2;
aluout <= alures;

process (memtoreg, alures, readdata) begin
if memtoreg = '0' then
    result <= alures;
else
    result <= readdata;
end if;
end process;

process(alusrc,RD2,signImm) begin
if alusrc = '0' then
    aluInputB <= RD2;
else
    aluInputB <= signImm;
end if;
end process;

signImm <= std_logic_vector(resize(signed(instruction(15 downto 0)),32));

--todo: figure out what is going wrong with the alu interfacing with registers.
--				potentially address getting corrupted somehow?
--todo: implement load and store
--todo: finish routing all signals
--todo: review all work
--todo: suffer <3

end;