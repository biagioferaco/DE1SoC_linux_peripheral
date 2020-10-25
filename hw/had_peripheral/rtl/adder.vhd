library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;

entity adder is
	generic ( WIDTH : natural );
	port (
			 DATAA  : in std_logic_vector(WIDTH-1 downto 0);
			 DATAB  : in std_logic_vector(WIDTH-1 downto 0);
			 RESULT : out std_logic_vector(WIDTH downto 0)
		 );
end adder;

architecture behaviour of adder is

	signal s_dataa  : unsigned(WIDTH downto 0);
	signal s_datab  : unsigned(WIDTH downto 0);
	signal s_result : unsigned(WIDTH downto 0);

begin

	s_dataa  <= unsigned(DATAA(WIDTH-1) & DATAA);
	s_datab  <= unsigned(DATAB(WIDTH-1) & DATAB);

	RESULT   <= std_logic_vector(s_result);

	s_result <= s_dataa + s_datab;

end behaviour;
