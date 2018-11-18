library ieee;
use ieee.std_logic_1164.all;

entity cla_eta is
	generic(n : natural);
	port
	(
		x_in      : in  std_logic_vector(n-1 downto 0);
		y_in      : in  std_logic_vector(n-1 downto 0);
		carry_in  : in  std_logic;
		sum       : out std_logic_vector(n-1 downto 0);
		carry_out : out std_logic
	);
end cla_eta;

architecture behavioral of cla_eta is

	signal h_sum             : std_logic_vector(n-1 downto 0);
	signal carry_generate    : std_logic_vector(n-1 downto 0);
	signal carry_propagate   : std_logic_vector(n-1 downto 0);
	signal carry_in_internal : std_logic_vector(n-1 downto 1);

begin

	h_sum           <= x_in xor y_in;
	carry_generate  <= x_in and y_in;
	carry_propagate <= x_in or y_in;

	process (carry_generate,carry_propagate,carry_in_internal)
	begin
		carry_in_internal(1) <= carry_generate(0);
		inst: for i in 1 to (n-1)-1 loop
			carry_in_internal(i+1) <= carry_generate(i) or (carry_propagate(i) and carry_in_internal(i));
		end loop;
		carry_out <= carry_generate(n-1) or (carry_propagate(n-1) and carry_in_internal(n-1));
	end process;

	sum(0)            <= h_sum(0) xor carry_in;
	sum(n-1 downto 1) <= h_sum(n-1 downto 1) xor carry_in_internal(n-1 downto 1);

end behavioral;
