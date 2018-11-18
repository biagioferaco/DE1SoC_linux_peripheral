library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;

entity ram_128_16 is
	port (
		     data      : in  std_logic_vector(sram_width-1 downto 0);
		     rdaddress : in  std_logic_vector(sram_loc_b-1 downto 0);
		     rdclock   : in  std_logic;
		     rden      : in  std_logic                                := '1';
		     wraddress : in  std_logic_vector(sram_loc_b-1 downto 0);
		     wrclock   : in  std_logic                                := '1';
		     wren      : in  std_logic                                := '0';
		     q         : out std_logic_vector(sram_width-1 downto 0)
	     );

end ram_128_16;

architecture rtl of ram_128_16 is

-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(sram_width-1 downto 0);
	type    memory_t is array(sram_loc-1 downto 0) of word_t;

-- Declare the RAM signal.
	signal ram : memory_t;

begin

	process(wrclock)
	begin
		if(rising_edge(wrclock)) then
			if(wren = '1') then
				ram(to_integer(unsigned(wraddress))) <= data;
			end if;
		end if;
	end process;

	process(rdclock)
	begin
		if(rising_edge(rdclock)) then
			if(rden = '1') then
				q <= ram(to_integer(unsigned(rdaddress)));
			end if;
		end if;
	end process;

end rtl;
