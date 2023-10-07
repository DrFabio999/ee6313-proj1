library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity mips is
    port
    (
        clk: in std_logic;
        reset: in std_logic;
        pcout: out std_logic_vector (31 downto 0);
        instr: in std_logic_vector (31 downto 0);
        memwrite: out std_logic;
        aluout: out std_logic_vector(31 downto 0);
        writedata: out std_logic_vector (31 downto 0);
        readdata: in std_logic_vector (31 downto 0);
    );
end entity mips;

architecture behavior of mips is

begin

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
        RD2: out std_logic_vector(31 downto 0);
    );
end component register_file;

component alu
    port
    (
        inputA: in std_logic_vector(31 downto 0);
        inputB: in std_logic_vector(31 downto 0);
        ALU_ctrl: in std_logic_vector(2 downto 0);
        ALU_result: out std_logic_vector(31 downto 0);
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
        alucontrol: out std_logic_vector(2 downto 0);
    );
end component controller;

signal memtoreg: std_logic;
signal memtowrite: std_logic;
signal pcsrc: std_logic;
signal alusrc: std_logic;
signal regdst: std_logic;
signal regwrite: std_logic;
signal jump: std_logic;
signal aluctl: std_logic_vector(2 downto 0);

signal aluInputB: std_logic_vector(31 downto 0);
signal A3: std_logic_vector(4 downto 0);
signal RD1: std_logic_vector(31 downto 0);
signal RD2: std_logic_vector(31 downto 0);
signal result: std_logic_vector(31 downto 0);


controller port map(op=>instr(31 downto 26), funct=>instr(5 downto 0),zero=>open,
                    memtoreg=>memtoreg,memtowrite=>memtowrite,pcsrc=>pcsrc,
                    alusrc=>alusrc,regdst=>regdst,regwrite=>regwrite,jump=>jump,
                    alucontrol=>aluctl);

alu port map(inputA=>RD1,inputB=>aluInputB,ALU_ctrl=>aluctl,ALU_result=>aluout);
register_file port map(A1=>instr(25 downto 21),A2=>instr(20 downto 16),A3=>A3,clk=>clk,WE3=>regwrite,WD3=>result,RD1=>RD1,RD2=>RD2);

if(regdst == '0') then
    A3 <= instr(20 downto 16);
else then
    A3 <= instr(15 downto 11);
end;

writedata <= RD2;

if(memtoreg == '0') then
    result <= aluout;
else
    result <= readdata;
end;

if(alusrc == '0') then
    aluInputB <= RD2;
else

end;

--todo: implement sign extend
--todo: implement PC
--todo: finish routing all signals
--todo: review all work
--todo: suffer <3

end;