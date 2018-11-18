library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic(n : natural);
	port(
		    D          : in  std_logic_vector(n-1 downto 0);
		    clock      : in  std_logic;
		    enable     : in  std_logic; --active high enable
		    sync_reset : in  std_logic; --active high synchronous reset
		    rst        : in  std_logic; --active high asynchronous reset
		    Q          : out std_logic_vector(n-1 downto 0)
	    );
end reg;

architecture behaviour of reg is
begin
	reg_gen: process(clock, rst)
	begin
		if rst = '1' then
			Q <= (others => '0');
		elsif rising_edge(clock) then
			if sync_reset = '1' then
				Q <= (others => '0');
			elsif enable = '1' then
				Q <= D;
			end if;
		end if;
	end process reg_gen;
end behaviour;
