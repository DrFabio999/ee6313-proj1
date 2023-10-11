library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity pc is
    port
    (
        clk: in std_logic;
        PCsrc: in std_logic;
        jump: in std_logic;
        immed: in std_logic_vector(31 downto 0);
        instr: in std_logic_vector(31 downto 0);
        pcout: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavior of pc is

signal PC_plus_4: std_logic_vector(31 downto 0) := (others => '0');
signal PC_count: std_logic_vector(31 downto 0) := (others => '0');
signal PC_branch: std_logic_vector(31 downto 0) := (others => '0');
signal PC_prime: std_logic_vector(31 downto 0) := (others => '0');
signal jump_addr: std_logic_vector(31 downto 0) := (others => '0');

begin

PC_plus_4 <= std_logic_vector(unsigned(pc_count) + 4);
PC_branch <= std_logic_vector((unsigned(immed) sll 2) + unsigned(PC_plus_4));
jump_addr <= std_logic_vector(resize((unsigned(instr(25 downto 0)) sll 2),32) or resize((unsigned(PC_plus_4(31 downto 26)) sll 28),32));

process(PCsrc,jump,jump_addr,PC_branch,PC_plus_4) begin
    if jump = '1' then
        PC_prime <= jump_addr;
    else
        if PCsrc = '1' then
            PC_prime <= PC_branch;
        else
            PC_prime <= PC_plus_4;
        end if;
    end if;
end process;

process(clk,PC_prime) begin
    if rising_edge(clk) then
        PC_count <= PC_prime;
        pcout <= PC_count;
    end if;
end process;

end architecture;