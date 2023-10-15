library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity pc is
    port
    (
        clk: in std_logic;
        PCsrc: in std_logic;
        jump: in std_logic;
		  reset: in std_logic;
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
signal pc_sel:std_logic_vector(1 downto 0) := (others => '0');

begin

PC_plus_4 <= std_logic_vector(unsigned(pc_count) + 4);
PC_branch <= std_logic_vector((unsigned(immed) sll 2) + unsigned(PC_plus_4));
jump_addr <= std_logic_vector(resize((unsigned(instr(25 downto 0)) sll 2),32) or resize((unsigned(PC_plus_4(31 downto 26)) sll 28),32));

pc_sel <= std_logic_vector'(jump & PCsrc); 
pcout <= PC_count;

process(reset,pc_sel,jump_addr,PC_branch,PC_plus_4,clk) begin --selecting the correct PC new value
		if reset = '1' then
			PC_prime <= (others=>'0');
		else
			if falling_edge(clk) then
			case pc_sel is
				when "00" =>
					PC_prime <= PC_plus_4;
				when "01" =>
					PC_prime <= PC_branch;
				when "10" =>
					PC_prime <= jump_addr;
				when "11" =>
					PC_prime <= jump_addr;
				when others =>
					PC_prime <= PC_plus_4;
			end case;
			end if;
		end if;
end process;

process(clk,PC_prime) begin
    if rising_edge(clk) then
        PC_count <= PC_prime;
    end if;
end process;

end architecture;