library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;                   --user defined package

entity HAD_b is
	port(
		    A : in  std_logic_vector(BITDEPTH_L01*DIM*DIM-1 downto 0);
		    B : out std_logic_vector(BITDEPTH_L07*DIM*DIM-1 downto 0)
	    );
end HAD_b;

architecture behaviour of HAD_b is

	component adder
		generic ( WIDTH : natural );
		port (
			     DATAA  : in std_logic_vector(WIDTH-1 downto 0);
			     DATAB  : in std_logic_vector(WIDTH-1 downto 0);
			     RESULT : out std_logic_vector(WIDTH downto 0)
		     );
	end component;

	component subtract
		generic ( WIDTH : natural );
		port (
			     DATAA  : in std_logic_vector(WIDTH-1 downto 0);
			     DATAB  : in std_logic_vector(WIDTH-1 downto 0);
			     RESULT : out std_logic_vector(WIDTH downto 0)
		     );
	end component;

-- horizontal signals

	type   h0 is array(0 to DIM*DIM-1) of std_logic_vector(BITDEPTH_L01-1 downto 0);
	type   h1 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L02-1 downto 0);
	type   h2 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L03-1 downto 0);
	type   h3 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L04-1 downto 0);

	signal m0 : h0;
	signal m1 : h1;
	signal m2 : h2;
	signal m3 : h3;

-- vertical signals

	type   d0 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L05-1 downto 0);
	type   d1 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L06-1 downto 0);
	type   d2 is array(0 to DIM-1, 0 to DIM-1) of std_logic_vector(BITDEPTH_L07-1 downto 0);

	signal m4 : d0;
	signal m5 : d1;
	signal m6 : d2;

begin

-- Horizontal

	sig_gen0 : for j in 0 to DIM-1 generate
		sig_gen1 : for i in 0 to DIM-1 generate

			m0((j*8) + i) <= A(BITDEPTH_L01*((j*8)+i+1)-1 downto BITDEPTH_L01*((j*8)+i));

		end generate sig_gen1;

	-- L0

		add00 : adder
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 0),
				 DATAB  => m0((j*8) + 4),
				 RESULT => m1(j, 0)
			 );

		add01 : adder
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 1),
				 DATAB  => m0((j*8) + 5),
				 RESULT => m1(j, 1)
			 );

		add02 : adder
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 2),
				 DATAB  => m0((j*8) + 6),
				 RESULT => m1(j, 2)
			 );

		add03 : adder
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 3),
				 DATAB  => m0((j*8) + 7),
				 RESULT => m1(j, 3)
			 );

		sub04 : subtract
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 0),
				 DATAB  => m0((j*8) + 4),
				 RESULT => m1(j, 4)
			 );

		sub05 : subtract
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 1),
				 DATAB  => m0((j*8) + 5),
				 RESULT => m1(j, 5)
			 );

		sub06 : subtract
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 2),
				 DATAB  => m0((j*8) + 6),
				 RESULT => m1(j, 6)
			 );


		sub07 : subtract
		generic map ( BITDEPTH_L01)
		port map (
				 DATAA  => m0((j*8) + 3),
				 DATAB  => m0((j*8) + 7),
				 RESULT => m1(j, 7)
			 );

-- L1

		add10 : adder
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 0),
				 DATAB  => m1(j, 2),
				 RESULT => m2(j, 0)
			 );

		add11 : adder
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 1),
				 DATAB  => m1(j, 3),
				 RESULT => m2(j, 1)
			 );

		sub12 : subtract
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 0),
				 DATAB  => m1(j, 2),
				 RESULT => m2(j, 2)
			 );

		sub13 : subtract
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 1),
				 DATAB  => m1(j, 3),
				 RESULT => m2(j, 3)
			 );

		add14 : adder
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 4),
				 DATAB  => m1(j, 6),
				 RESULT => m2(j, 4)
			 );

		add15 : adder
		generic map ( BITDEPTH_L02 )
		port map (
				 DATAA  => m1(j, 5),
				 DATAB  => m1(j, 7),
				 RESULT => m2(j, 5)
			 );

		sub16 : subtract
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 4),
				 DATAB  => m1(j, 6),
				 RESULT => m2(j, 6)
			 );

		sub17 : subtract
		generic map ( BITDEPTH_L02)
		port map (
				 DATAA  => m1(j, 5),
				 DATAB  => m1(j, 7),
				 RESULT => m2(j, 7)
			 );

-- L2

		add20 : adder
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 0),
				 DATAB  => m2(j, 1),
				 RESULT => m3(j, 0)
			 );

		sub21 : subtract
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 0),
				 DATAB  => m2(j, 1),
				 RESULT => m3(j, 1)
			 );

		add22 : adder
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 2),
				 DATAB  => m2(j, 3),
				 RESULT => m3(j, 2)
			 );

		sub23 : subtract
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 2),
				 DATAB  => m2(j, 3),
				 RESULT => m3(j, 3)
			 );

		add24 : adder
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 4),
				 DATAB  => m2(j, 5),
				 RESULT => m3(j, 4)
			 );

		sub25 : subtract
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 4),
				 DATAB  => m2(j, 5),
				 RESULT => m3(j, 5)
			 );

		add26 : adder
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 6),
				 DATAB  => m2(j, 7),
				 RESULT => m3(j, 6)
			 );

		sub27 : subtract
		generic map ( BITDEPTH_L03 )
		port map (
				 DATAA  => m2(j, 6),
				 DATAB  => m2(j, 7),
				 RESULT => m3(j, 7)
			 );


	end generate sig_gen0;

-- Vertical

	sig_gen2 : for j in 0 to DIM-1 generate
		sig_gen3 : for i in 0 to DIM-1 generate

			B(BITDEPTH_L07*((j*8)+i+1)-1 downto BITDEPTH_L07*((j*8)+i)) <= m6(i, j);

		end generate sig_gen3;

-- L3

		add30 : adder
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(0, j),
				 DATAB  => m3(4, j),
				 RESULT => m4(0, j)
			 );

		add31 : adder
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(1, j),
				 DATAB  => m3(5, j),
				 RESULT => m4(1, j)
			 );

		add32 : adder
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(2, j),
				 DATAB  => m3(6, j),
				 RESULT => m4(2, j)
			 );

		add33 : adder
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(3, j),
				 DATAB  => m3(7, j),
				 RESULT => m4(3, j)
			 );

		sub34 : subtract
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(0, j),
				 DATAB  => m3(4, j),
				 RESULT => m4(4, j)
			 );

		sub35 : subtract
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(1, j),
				 DATAB  => m3(5, j),
				 RESULT => m4(5, j)
			 );

		sub36 : subtract
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(2, j),
				 DATAB  => m3(6, j),
				 RESULT => m4(6, j)
			 );

		sub37 : subtract
		generic map ( BITDEPTH_L04 )
		port map (
				 DATAA  => m3(3, j),
				 DATAB  => m3(7, j),
				 RESULT => m4(7, j)
			 );

-- L4

		add40 : adder
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(0, j),
				 DATAB  => m4(2, j),
				 RESULT => m5(0, j)
			 );

		add41 : adder
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(1, j),
				 DATAB  => m4(3, j),
				 RESULT => m5(1, j)
			 );

		sub42 : subtract
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(0, j),
				 DATAB  => m4(2, j),
				 RESULT => m5(2, j)
			 );

		sub43 : subtract
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(1, j),
				 DATAB  => m4(3, j),
				 RESULT => m5(3, j)
			 );

		add44 : adder
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(4, j),
				 DATAB  => m4(6, j),
				 RESULT => m5(4, j)
			 );

		add45 : adder
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(5, j),
				 DATAB  => m4(7, j),
				 RESULT => m5(5, j)
			 );

		sub46 : subtract
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(4, j),
				 DATAB  => m4(6, j),
				 RESULT => m5(6, j)
			 );

		sub47 : subtract
		generic map ( BITDEPTH_L05 )
		port map (
				 DATAA  => m4(5, j),
				 DATAB  => m4(7, j),
				 RESULT => m5(7, j)
			 );

--L5

		add50 : adder
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(0, j),
				 DATAB  => m5(1, j),
				 RESULT => m6(0, j)
			 );

		sub51 : subtract
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(0, j),
				 DATAB  => m5(1, j),
				 RESULT => m6(1, j)
			 );

		add52 : adder
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(2, j),
				 DATAB  => m5(3, j),
				 RESULT => m6(2, j)
			 );

		sub53 : subtract
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(2, j),
				 DATAB  => m5(3, j),
				 RESULT => m6(3, j)
			 );

		add54 : adder
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(4, j),
				 DATAB  => m5(5, j),
				 RESULT => m6(4, j)
			 );

		sub55 : subtract
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(4, j),
				 DATAB  => m5(5, j),
				 RESULT => m6(5, j)
			 );

		add56 : adder
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(6, j),
				 DATAB  => m5(7, j),
				 RESULT => m6(6, j)
			 );

		sub57 : subtract
		generic map ( BITDEPTH_L06 )
		port map (
				 DATAA  => m5(6, j),
				 DATAB  => m5(7, j),
				 RESULT => m6(7, j)
			 );

	end generate sig_gen2;

end behaviour;
