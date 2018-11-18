library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;   --user defined package

entity subtract is
	generic ( WIDTH : natural );
	port (
		     DATAA  : in  std_logic_vector(WIDTH-1 downto 0);
		     DATAB  : in  std_logic_vector(WIDTH-1 downto 0);
		     RESULT : out std_logic_vector(WIDTH downto 0)
	     );
end subtract;

architecture behaviour of subtract is

	signal s_dataa  : signed(WIDTH downto 0);
	signal s_datab  : signed(WIDTH downto 0);
	signal s_result : signed(WIDTH downto 0);

begin

	s_dataa  <= signed(DATAA(WIDTH-1) & DATAA);
	s_datab  <= signed(DATAB(WIDTH-1) & DATAB);

	RESULT   <= std_logic_vector(s_result);

	s_result <= s_dataa - s_datab;

end behaviour;
