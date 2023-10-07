library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

type std_logic_array_of_vector is array(natural range<>,natural range<>);

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
        RD2: out std_logic_vector(31 downto 0);
    );
end entity register_file;

architecture behavior of register_file is

component regis is
    port
    (
        clk: in std_logic;
        rst: in std_logic;
        d_in: in std_logic_vector(7 downto 0); -- input1
        d_out: out std_logic_vector(7 downto 0); -- output, 1 bit wider    
    );
end component regis;

signal selR1: std_logic_vector(31 downto 0);
signal selR2: std_logic_vector(31 downto 0);
signal selW1: std_logic_vector(31 downto 0);
signal data: std_logic_array_of_vector(0 to 31, 31 downto 0);

begin


for i in (31 downto 0) generate

    if((to_integer(unsigned(A3)) == i) and (WE3 == 1)) then
        selW1(i) <= '1' others => '0'
    end

    regis port map(clk =>selW1(i),rst=>open,d_in=>WD3,d_out=>data(i,31 downto 0));

end

RD1 <= data(to_integer(unsigned(A1)),31 downto 0);
RD2 <= data(to_integer(unsigned(A2)),31 downto 0);

end architecture