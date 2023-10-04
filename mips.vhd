library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity mips is
    port
    (
        clk: in std_logic 
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

component dmem
    port
    (
        clk: in std_logic;
        we: in std_logic;
        a: in std_logic_vector(31 downto 0);
        wd: in std_logic_vector(31 downto 0);
        rd: out std_logic_vector(31 downto 0);
    );
end component dmem;

component imem
    port
    (
        a: in std_logic_vector(5 downto 0);
        rd: out std_logic_vector(31 downto 0);
    );
end component imem;

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