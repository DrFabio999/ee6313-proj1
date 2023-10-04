library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity full_adder is
    port
    (
        inpA: in std_logic
        inpB: in std_logic
        carryIn: in std_logic
        res: out std_logic
        carryOut: out std_logic
    );
end full_adder;

architecture behavior of full_adder is
    
begin

component half_adder
port
(
    inA: in std_logic;
    inB: in std_logic;
    result: out std_logic;
    carry: out std_logic;
);
end component half_adder;

signal x: std_logic;
signal c1: std_logic;
signal c2: std_logic;
half_adder port map(inA=>inpA, inB=>inpB, result=>x, carry=>c1);
half_adder port map(inA=>x, inB=>carryIn,result=>res,carry=c2);

carryOut <= c1 or c2;

end;