library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;                   --user defined package

entity SAV is
    port(
            A: in   std_logic_vector(BITDEPTH_L07*DIM*DIM-1 downto 0);
            B: out  std_logic_vector(BITDEPTH_L14-1 downto 0)
        );
end SAV;

architecture behaviour of SAV is

component adder
    generic ( WIDTH : natural );
    port (
            DATAA  : in std_logic_vector(WIDTH-1 downto 0);
            DATAB  : in std_logic_vector(WIDTH-1 downto 0);
            RESULT : out std_logic_vector(WIDTH downto 0)
        );
end component;

type   u0 is array(0 to DIM*DIM-1) 		of signed(BITDEPTH_L07-1 downto 0);
type   d0 is array(0 to DIM*DIM-1) 		of std_logic_vector(BITDEPTH_L07-1 downto 0);
type   d1 is array(0 to (DIM*DIM/2)-1) 	of std_logic_vector(BITDEPTH_L08-1 downto 0);
type   d2 is array(0 to (DIM*DIM/4)-1) 	of std_logic_vector(BITDEPTH_L09-1 downto 0);
type   d3 is array(0 to (DIM*DIM/8)-1) 	of std_logic_vector(BITDEPTH_L10-1 downto 0);
type   d4 is array(0 to (DIM*DIM/16)-1)	of std_logic_vector(BITDEPTH_L11-1 downto 0);
type   d5 is array(0 to (DIM*DIM/32)-1)	of std_logic_vector(BITDEPTH_L12-1 downto 0);

signal a00 : u0;
signal a0  : d0;
signal a1  : d1;
signal a2  : d2;
signal a3  : d3;
signal a4  : d4;
signal a5  : d5;
signal a6  : std_logic_vector(BITDEPTH_L13-1 downto 0);


begin

	sig_gen : for i in 0 to (DIM*DIM)-1 generate
		a00(i) <= abs(signed(A(BITDEPTH_L07*(i+1)-1 downto BITDEPTH_L07*i)));
		a0(i) <= std_logic_vector(a00(i));
	end generate sig_gen;

	add_gen0 : for i in 0 to (DIM*DIM/2)-1 generate
	add00 : adder
		generic map ( BITDEPTH_L07 )
		port map
		(
			DATAA  => a0(2*i),
			DATAB  => a0((2*i)+1),
			RESULT => a1(i)
		);
	end generate add_gen0;

	add_gen1 : for i in 0 to (DIM*DIM/4)-1 generate
	add01 : adder
		generic map ( BITDEPTH_L08 )
		port map
		(
			DATAA  => a1(2*i),
			DATAB  => a1((2*i)+1),
			RESULT => a2(i)
		);
	end generate add_gen1;

	add_gen2 : for i in 0 to (DIM*DIM/8)-1 generate
	add02 : adder
		generic map ( BITDEPTH_L09 )
		port map (
			DATAA  => a2(2*i),
			DATAB  => a2((2*i)+1),
			RESULT => a3(i)
		);
	end generate add_gen2;

	add_gen3 : for i in 0 to (DIM*DIM/16)-1 generate
	add03 : adder
		generic map ( BITDEPTH_L10 )
		port map
		(
			DATAA  => a3(2*i),
			DATAB  => a3((2*i)+1),
			RESULT => a4(i)
		);
	end generate add_gen3;

	add_gen4 : for i in 0 to (DIM*DIM/32)-1 generate
	add04 : adder
		generic map ( BITDEPTH_L11)
		port map (
			DATAA  => a4(2*i),
			DATAB  => a4((2*i)+1),
			RESULT => a5(i)
		);

	end generate add_gen4;

	add05 : adder
		generic map ( BITDEPTH_L12)
		port map (
			DATAA  => a5(0),
			DATAB  => a5(1),
			RESULT => a6
		);

	add06 : adder
		generic map ( BITDEPTH_L13)
		port map (
			DATAA  => a6,
			DATAB  => std_logic_vector(to_unsigned(2, BITDEPTH_L13)),
			RESULT => B
		);

end behaviour;
