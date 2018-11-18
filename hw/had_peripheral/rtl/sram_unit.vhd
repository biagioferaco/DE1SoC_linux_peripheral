library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;

entity sram_unit is
	port (
		     addr1   : in  std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);
		     addr2   : in  std_logic_vector(sram_loc_b-1 downto 0);
		     clock1  : in  std_logic;
		     clock2  : in  std_logic;
		     WEB1    : in  std_logic;
		     CSB2    : in  std_logic_vector(sram_units-1 downto 0);
		     datain  : in  std_logic_vector(sram_width-1 downto 0);
		     dataout : out std_logic_vector(sram_units*sram_width-1 downto 0)
	     );
end sram_unit;

architecture behaviour of sram_unit is
--generic sram:
	component ram_128_16 is
		port (
			     data      : in  std_logic_vector (sram_width-1 downto 0);
			     rdaddress : in  std_logic_vector (sram_loc_b-1 downto 0);
			     rdclock   : in  std_logic;
			     rden      : in  std_logic                                 := '1';
			     wraddress : in  std_logic_vector (sram_loc_b-1 downto 0);
			     wrclock   : in  std_logic                                 := '1';
			     wren      : in  std_logic                                 := '0';
			     q         : out std_logic_vector (sram_width-1 downto 0)
		     );
	end component;

--signals:
	type   dout is array(0 to sram_units-1) of std_logic_vector(sram_width-1 downto 0);
	type   din  is array(0 to sram_units-1) of std_logic_vector(sram_width-1 downto 0);

	signal d2         : dout;
	signal d1         : din;
	signal we         : std_logic_vector(sram_units-1 downto 0);
	signal addr_units : std_logic_vector(sram_units_b-1 downto 0);

begin


--library 16x128 sram block:
	sram_gen : for i in 0 to sram_units-1 generate
		dataout(sram_width*(i+1)-1 downto sram_width*i) <= d2(i) when CSB2(i) = '1' else (others => '0');
		d1(i) <= datain;

		ram_128_16_inst : ram_128_16
		port map (
				 data      => d1(i),
				 rdaddress => addr2,
				 rdclock   => clock2,
				 rden      => CSB2(i),
				 wraddress => addr1(7 downto 4),
				 wrclock   => clock1,
				 wren      => we(i),
				 q         => d2(i)
			 );
	end generate sram_gen;

	CTRL_EN : process (addr1, WEB1)

	begin

		if WEB1 = '1' then
			case( addr1(3 downto 0) ) is
				when "0000" =>
					we <= "0000000000000001";
				when "0001" =>
					we <= "0000000000000010";
				when "0010" =>
					we <= "0000000000000100";
				when "0011" =>
					we <= "0000000000001000";
				when "0100" =>
					we <= "0000000000010000";
				when "0101" =>
					we <= "0000000000100000";
				when "0110" =>
					we <= "0000000001000000";
				when "0111" =>
					we <= "0000000010000000";
				when "1000" =>
					we <= "0000000100000000";
				when "1001" =>
					we <= "0000001000000000";
				when "1010" =>
					we <= "0000010000000000";
				when "1011" =>
					we <= "0000100000000000";
				when "1100" =>
					we <= "0001000000000000";
				when "1101" =>
					we <= "0010000000000000";
				when "1110" =>
					we <= "0100000000000000";
				when "1111" =>
					we <= "1000000000000000";
				when others =>
					we <= (others => '0');
			end case ;
		else
			we <= (others => '0');
		end if;

	end process ; -- CTRL_EN

end behaviour;
