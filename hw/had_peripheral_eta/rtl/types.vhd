--user defined package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package type_def is

----functions:
	function log2_natural( x : natural ) return natural;
--function sl2int (x: std_logic) return integer;

--constants:
	constant BITDEPTH_L00 : natural; --pixel bits
	constant BITDEPTH_L01 : natural; --pixel bits+1
	constant BITDEPTH_L02 : natural; --pixel bits+2
	constant BITDEPTH_L03 : natural; --pixel bits+3
	constant BITDEPTH_L04 : natural; --pixel bits+4
	constant BITDEPTH_L05 : natural; --pixel bits+5
	constant BITDEPTH_L06 : natural; --pixel bits+6
	constant BITDEPTH_L07 : natural; --pixel bits+7
	constant BITDEPTH_L08 : natural; --pixel bits+8
	constant BITDEPTH_L09 : natural; --pixel bits+9
	constant BITDEPTH_L10 : natural; --pixel bits+10
	constant BITDEPTH_L11 : natural; --pixel bits+11
	constant BITDEPTH_L12 : natural; --pixel bits+12
	constant BITDEPTH_L13 : natural; --pixel bits+12
	constant BITDEPTH_L14 : natural; --pixel bits+14

	constant BITDEPTH_L15 : natural; --pixel bits+15
	constant BITDEPTH_L16 : natural; --pixel bits+16
	constant BITDEPTH_L17 : natural; --pixel bits+17

	constant CELLDIM      : natural; --max block dimension
	constant DIM          : natural; --dimension

	constant sram_loc     : natural; --sram words
	constant sram_loc_b   : natural; --sram words in bits
	constant sram_units   : natural; --sram blocks
	constant sram_units_b : natural; --sram blocks in bits
	constant sram_width   : natural; --sram width (bits)

	constant seg_width    : natural; --segment width
	constant num_prec_seg : natural;


end type_def;

package body type_def is

--functions:
--computes the log2 value of a natural number. The result is natural.
	function log2_natural ( x : natural ) return natural is
	variable temp : natural := x;
	variable n : natural := 0;
	begin
		while temp > 1 loop
			temp := temp / 2;
			n := n + 1;
		end loop;
		return n;
	end function log2_natural;

--constants:
	constant BITDEPTH_L00 : natural := 8;
	constant BITDEPTH_L01 : natural := 9;
	constant BITDEPTH_L02 : natural := 10;
	constant BITDEPTH_L03 : natural := 11;
	constant BITDEPTH_L04 : natural := 12;
	constant BITDEPTH_L05 : natural := 13;
	constant BITDEPTH_L06 : natural := 14;
	constant BITDEPTH_L07 : natural := 15;
	constant BITDEPTH_L08 : natural := 16;
	constant BITDEPTH_L09 : natural := 17;
	constant BITDEPTH_L10 : natural := 18;
	constant BITDEPTH_L11 : natural := 19;
	constant BITDEPTH_L12 : natural := 20;
	constant BITDEPTH_L13 : natural := 21;
	constant BITDEPTH_L14 : natural := 22;

	constant BITDEPTH_L15 : natural := 23;
	constant BITDEPTH_L16 : natural := 24;
	constant BITDEPTH_L17 : natural := 25;

	constant CELLDIM      : natural := 4;
	constant DIM          : natural := 8;

	constant sram_loc     : natural := 16;
	constant sram_loc_b   : natural := log2_natural(sram_loc);
	constant sram_units   : natural := 16;
	constant sram_units_b : natural := log2_natural(sram_units);
	constant sram_width   : natural := 128;


	constant seg_width    : natural := 4; --segment width
	constant num_prec_seg : natural := 2; --num prec segme

end type_def;
