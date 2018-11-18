library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity etaiim is
	generic(
		       m : natural;  -- bitwidth of the adder
		       n : natural;  -- width of the segment
		       k : natural
	       );
	port (
		a         : in   std_logic_vector(m-1 downto 0);
		b         : in   std_logic_vector(m-1 downto 0);
		carry_in  : in   std_logic;
		s         : out  std_logic_vector(m-1 downto 0);
		carry_out : out  std_logic
	);
end etaiim;

architecture behavioral of etaiim is

	component cla is
		generic(n : natural);
		port (
			x_in      : in   std_logic_vector(n-1 downto 0);
			y_in      : in   std_logic_vector(n-1 downto 0);
			carry_in  : in   std_logic;
			sum       : out  std_logic_vector(n-1 downto 0);
			carry_out : out  std_logic
		);
	end component;

	component cla_eta is
		generic(n : natural);
		port (
			x_in      : in   std_logic_vector(n-1 downto 0);
			y_in      : in   std_logic_vector(n-1 downto 0);
			carry_in  : in   std_logic;
			sum       : out  std_logic_vector(n-1 downto 0);
			carry_out : out  std_logic
		);
	end component;

	component rca2 is
		port (
			    x_in  : in std_logic_vector(1 downto 0);
			    y_in  : in std_logic_vector(1 downto 0);
			    c_in  : in std_logic;
			    sum   : out std_logic_vector(1 downto 0);
			    c_out : out std_logic);
	end component;

	component full_add is
		port (
			    a     : in  std_logic;
			    b     : in  std_logic;
			    c_in  : in  std_logic;
			    sum   : out std_logic;
			    c_out : out std_logic
		    );
	end component;

	type c0 is array(0 to m/n) of std_logic;
	type c1 is array(0 to 1) of std_logic;

	signal cint0 : c0;
	signal cint1 : c0;
	signal cint2 : c1;
	signal cint3 : c1;
	signal cint4 : c1;

begin

	gen0 : for i in 0 to k-1 generate

		add0 : cla
		generic map(n)
		port map(
				x_in      => a((m-i*n)-1 downto (m-(i+1)*n)),
				y_in      => b((m-i*n)-1 downto (m-(i+1)*n)),
				carry_in  => cint0(i+1),
				sum       => s((m-i*n)-1 downto (m-(i+1)*n)),
				carry_out => cint0(i)
			);
	end generate;

	lwbit : if m-k*n > 0 generate
		h0 : if m-k*n >= n generate
			gen1 : for i in k to (m/n)-1 generate

				add1 : cla_eta
				generic map(n)
				port map(
						x_in      => a((m-i*n)-1 downto (m-(i+1)*n)),
						y_in      => b((m-i*n)-1 downto (m-(i+1)*n)),
						carry_in  => cint1(i+1),
						sum       => s((m-i*n)-1 downto (m-(i+1)*n)),
						carry_out => cint1(i)
					);
			end generate;
		end generate;

		h1 : if (m rem n) > 2 generate

			add2 : cla_eta
			generic map(m rem n)
			port map(
					x_in      => a((m rem n)-1 downto 0),
					y_in      => b((m rem n)-1 downto 0),
					carry_in  => cint2(1),
					sum       => s((m rem n)-1 downto 0),
					carry_out => cint2(0)
				);

		end generate;

		h2 : if (m rem n) = 2 generate
			add3 : rca2
			port map(
					x_in  => a(1 downto 0),
					y_in  => b(1 downto 0),
					c_in  => cint3(1),
					sum   => s(1 downto 0),
					c_out => cint3(0)
				);

		end generate;

		h3 : if (m rem n) = 1 generate

			add4 : full_add
			port map(
					a     => a(0),
					b     => b(0),
					c_in  => cint4(1),
					sum   => s(0),
					c_out => cint4(0)
				);

		end generate;

	end generate;

	r0 : if m-k*n = 0 generate

		cint0(k) <= carry_in;

	end generate;

	r1 : if m-k*n > 0 generate

		r2 : if (m-k*n >= n) and ((m rem n)=0) generate

			cint0(k)   <= cint1(k);
			cint1(m/n) <= carry_in;

		end generate;

		r3 : if (m-k*n >= n) and ((m rem n)>2) generate

			cint0(k)   <= cint1(k);
			cint1(m/n) <= cint2(0);
			cint2(1)   <= carry_in;

		end generate;

		r4 : if (m-k*n >= n) and ((m rem n)=2) generate

			cint0(k)   <= cint1(k);
			cint1(m/n) <= cint3(0);
			cint3(1)   <= carry_in;

		end generate;

		r5 : if (m-k*n >= n) and ((m rem n)=1) generate

			cint0(k)   <= cint1(k);
			cint1(m/n) <= cint4(0);
			cint4(1)   <= carry_in;

		end generate;


	end generate;

	r6 : if (m-k*n > 0) and (m-k*n < n) generate

		r7 : if (m rem n) > 2 generate

			cint0(k) <= cint2(0);
			cint2(1) <= carry_in;

		end generate;

		r8 : if (m rem n) = 2 generate

			cint0(k) <= cint3(0);
			cint3(1) <= carry_in;

		end generate;

		r9 : if (m rem n) = 1 generate

			cint0(k) <= cint4(0);
			cint4(1) <= carry_in;

		end generate;

	end generate;

	carry_out <= cint0(0);

end behavioral;
