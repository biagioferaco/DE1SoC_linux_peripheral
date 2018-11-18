library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;                   --user defined package

entity adder is
	generic ( WIDTH : natural );
	port (
		     DATAA  : in  std_logic_vector(WIDTH-1 downto 0);
		     DATAB  : in  std_logic_vector(WIDTH-1 downto 0);
		     RESULT : out std_logic_vector(WIDTH downto 0)
	     );
end adder;

architecture behaviour of adder is

	component ETAIIM IS
		generic (
				M      : natural;  -- bitwidth of the adder
				N      : natural;  -- width of the segment
				K      : natural
			);
		port (
			     A         : in  std_logic_vector(M-1 DOWNTO 0);
			     B         : in  std_logic_vector(M-1 DOWNTO 0);
			     carry_in  : in  std_logic;
			     S         : out std_logic_vector(M-1 DOWNTO 0);
			     carry_out : out std_logic
		     );
	end component;

	signal cout : std_logic;

begin

	c0   : ETAIIM
	generic map(WIDTH + 1, seg_width, num_prec_seg)
	port map
	(
		DATAA(WIDTH-1) & DATAA,
		DATAB(WIDTH-1) & DATAB,
		'0',
		RESULT(WIDTH downto 0),
		cout
	);

end behaviour;
