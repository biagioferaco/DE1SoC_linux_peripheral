library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;                   --user defined package

entity DIFF is
	port(
		    A0 : in  std_logic_vector(BITDEPTH_L00*DIM*DIM-1 downto 0);
		    A1 : in  std_logic_vector(BITDEPTH_L00*DIM*DIM-1 downto 0);
		    B  : out std_logic_vector(BITDEPTH_L01*DIM*DIM-1 downto 0)
	    );
end DIFF;

architecture behaviour of DIFF is

	component subtract
		generic ( WIDTH : natural );
		port (
			     DATAA  : in std_logic_vector(WIDTH-1 downto 0);
			     DATAB  : in std_logic_vector(WIDTH-1 downto 0);
			     RESULT : out std_logic_vector(WIDTH downto 0)
		     );
	end component;

	type   d0 is array(0 to (DIM*DIM)-1)	of std_logic_vector(BITDEPTH_L01 downto 0);

	signal B_temp : d0;

begin

	sig_gen : for i in 0 to (DIM*DIM)-1 generate

		sub00 : subtract
		generic map ( BITDEPTH_L01 )
		port map (
				 DATAA  => '0' & A0(BITDEPTH_L00*(i+1)-1 downto BITDEPTH_L00*i),
				 DATAB  => '0' & A1(BITDEPTH_L00*(i+1)-1 downto BITDEPTH_L00*i),
				 RESULT => B_temp(i)
			 );

		B(BITDEPTH_L01*(i+1)-1 downto BITDEPTH_L01*i) <= B_temp(i)(BITDEPTH_L01-1 downto 0);

	end generate sig_gen;

end behaviour;
