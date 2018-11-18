library ieee;
use ieee.std_logic_1164.all;

entity full_add is
	port(
		    a     : in  std_logic;
		    b     : in  std_logic;
		    c_in  : in  std_logic;
		    sum   : out std_logic;
		    c_out : out std_logic);
end full_add;

architecture behv of full_add is
begin
	sum   <= a xor b xor c_in;
	c_out <= (a and b) or (c_in and (a or b));
end behv;
