library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity latch_0 is
	port(
		D          : in  std_logic;
		clock      : in  std_logic;
		enable     : in  std_logic; --active high enable
		sync_reset : in  std_logic; --active high synchronous reset
		rst        : in  std_logic; --active high asynchronous reset
		Q          : out std_logic
	);
end latch_0;

architecture behaviour of latch_0 is
begin
	latch_gen: process(clock, rst)
	begin
		if rst = '1' then
			Q <= '0';
		elsif rising_edge(clock) then
			if sync_reset = '1' then
				Q <= '0';
			elsif enable = '1' then
				Q <= D;
			end if;
		end if;
	end process latch_gen;

end behaviour;
