library ieee;
use ieee.std_logic_1164.all;

entity rca2 is
	port(
		x_in  : in  std_logic_vector(1 downto 0);
		y_in  : in  std_logic_vector(1 downto 0);
		c_in  : in  std_logic;
		sum   : out std_logic_vector(1 downto 0);
		c_out : out std_logic);
end rca2;

architecture struct of rca2 is

	component full_add is
		port(
			a     : in  std_logic;
			b     : in  std_logic;
			c_in  : in  std_logic;
			sum   : out std_logic;
			c_out : out std_logic);
	end component;

	signal im : std_logic;

begin

	c0   : full_add
	port map (x_in(0),y_in(0),c_in,sum(0),im);
		  c1 : full_add
		  port map (x_in(1),y_in(1),im,sum(1),c_out);

end struct;
