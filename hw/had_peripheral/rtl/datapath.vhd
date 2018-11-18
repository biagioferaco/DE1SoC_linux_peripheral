library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;

entity DATAPATH is
	port (
		cur_write       : in  std_logic;
		cur_writedata   : in  std_logic_vector(sram_width-1 downto 0);
		cur_waitrequest : out std_logic;
		cur_address     : in  std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);

		ref_write       : in  std_logic;
		ref_writedata   : in  std_logic_vector(sram_width-1 downto 0);
		ref_waitrequest : out std_logic;
		ref_address     : in  std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);

		rd_address      : in  std_logic_vector(sram_loc_b-1 downto 0);
		rd_enable       : in  std_logic_vector(sram_units-1 downto 0);
		SEL             : in  std_logic_vector(1 downto 0);
		P_EN            : in  std_logic_vector(2 downto 0);

		SATD            : out std_logic_vector(BITDEPTH_L17-1 downto 0);

		reset           : in  std_logic;
		sync_reset      : in  std_logic;
		clock_0_clk     : in  std_logic;                        -- 100MHz
		clock_1_clk     : in  std_logic                         -- 50MHz

	);

end DATAPATH;

architecture behaviour of DATAPATH is

	signal cur_write_s     : std_logic;
	signal cur_writedata_s : std_logic_vector(sram_width-1 downto 0);
	signal cur_address_s   : std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);

	signal ref_write_s     : std_logic;
	signal ref_writedata_s : std_logic_vector(sram_width-1 downto 0);
	signal ref_address_s   : std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);

	signal ref_readdata    : std_logic_vector(BITDEPTH_L00*DIM*DIM*CELLDIM-1 downto 0);
	signal cur_readdata    : std_logic_vector(BITDEPTH_L00*DIM*DIM*CELLDIM-1 downto 0);

	type f0 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L00*DIM*DIM-1 downto 0);
	type d0 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L01*DIM*DIM-1 downto 0);
	type d1 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L07*DIM*DIM-1 downto 0);
	type d3 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L14-1 downto 0);
	type d4 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L12-1 downto 0);
	type d6 is array(0 to CELLDIM-1) of std_logic_vector(BITDEPTH_L13-1 downto 0);

	signal y0,y1  : f0;
	signal s0     : d0;
	signal s1, s2 : d1;
	signal s3     : d3;
	signal s4, s5 : d4;
	signal s6     : d6;
	signal s7     : std_logic_vector(BITDEPTH_L17-1 downto 0);
	signal s8     : std_logic_vector(BITDEPTH_L17-1 downto 0);
	signal s9     : std_logic_vector(BITDEPTH_L17 downto 0);


--type 	 p0 is array(0 to 2) of std_logic;
	signal P_EN_1                         : std_logic_vector(2 downto 0);
	signal P_EN_2                         : std_logic_vector(1 downto 0);
	signal pipe_0, pipe_1, pipe_2, pipe_3 : std_logic;

component adder
generic ( WIDTH : natural );
port (	DATAA 	 	: in std_logic_vector(WIDTH-1 downto 0);
   DATAB	 	: in std_logic_vector(WIDTH-1 downto 0);
   RESULT	 	: out std_logic_vector(WIDTH downto 0)
   );
end component;

component sram_unit is
port(
addr1   : in  std_logic_vector(sram_loc_b+sram_units_b-1 downto 0);
addr2   : in  std_logic_vector(sram_loc_b-1 downto 0);
clock1 	: in  std_logic;
clock2 	: in  std_logic;
WEB1: in  std_logic;
CSB2: in  std_logic_vector(sram_units-1 downto 0);
datain  : in  std_logic_vector(sram_width-1 downto 0);
dataout : out std_logic_vector(sram_units*sram_width-1 downto 0)
);
end component;

component DIFF is
	port(
		    A0 : in  std_logic_vector(BITDEPTH_L00*DIM*DIM-1 downto 0);
		    A1 : in  std_logic_vector(BITDEPTH_L00*DIM*DIM-1 downto 0);
		    B  : out std_logic_vector(BITDEPTH_L01*DIM*DIM-1 downto 0)
	    );
end component;

component HAD_b is
	port(
		    A : in  std_logic_vector(BITDEPTH_L01*DIM*DIM-1 downto 0);
		    B : out std_logic_vector(BITDEPTH_L07*DIM*DIM-1 downto 0)
	    );
end component;


component SAV is
	port(
		    A : in  std_logic_vector(BITDEPTH_L07*DIM*DIM-1 downto 0);
		    B : out std_logic_vector(BITDEPTH_L14-1 downto 0)
	    );
end component;

component reg is
	generic(n : natural);
	port(
		    D          : in std_logic_vector(n-1 downto 0);
		    clock      : in std_logic;
		    enable     : in std_logic; --active high enable
		    sync_reset : in std_logic; --active low synchronous reset
		    rst        : in std_logic; --active low asynchronous reset
		    Q          : out std_logic_vector(n-1 downto 0)
	    );
end component;

component latch_0 is
	port(
		    D          : in std_logic;
		    clock      : in std_logic;
		    enable     : in std_logic; --active high enable
		    sync_reset : in std_logic; --active high synchronous reset
		    rst        : in std_logic; --active high asynchronous reset
		    Q          : out std_logic
	    );
end component;

begin

	pipe_cur_address_inst: reg
	generic map(sram_loc_b+sram_units_b)
	port map(
			D          => cur_address,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => cur_address_s
		);

	pipe_cur_writedata_inst: reg
	generic map(sram_width)
	port map(
			D          => cur_writedata,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => cur_writedata_s
		);

	pipe_cur_write_inst: latch_0
	port map(
			D          => cur_write,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => cur_write_s
		);


	pipe_ref_address_inst: reg
	generic map(sram_loc_b+sram_units_b)
	port map(
			D          => ref_address,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => ref_address_s
		);

	pipe_ref_writedata_inst: reg
	generic map(sram_width)
	port map(
			D          => ref_writedata,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => ref_writedata_s
		);

	pipe_ref_write_inst: latch_0
	port map(
			D          => ref_write,
			clock      => clock_0_clk,
			enable     => '1',
			sync_reset => '0',
			rst        => reset,
			Q          => ref_write_s
		);

-- ram

	cur_ram_inst: sram_unit
	port map (
			 addr1   => cur_address_s,
			 addr2   => rd_address,
			 clock1  => clock_0_clk,
			 clock2  => clock_1_clk,
			 WEB1    => cur_write_s,
			 CSB2    => rd_enable,
			 datain  => cur_writedata_s,
			 dataout => cur_readdata
		 );

	ref_ram_inst: sram_unit
	port map (
			 addr1   => ref_address_s,
			 addr2   => rd_address,
			 clock1  => clock_0_clk,
			 clock2  => clock_1_clk,
			 WEB1    => ref_write_s,
			 CSB2    => rd_enable,
			 datain  => ref_writedata_s,
			 dataout => ref_readdata
		 );

	datapath_gen : for i in 0 to CELLDIM-1 generate

-- pipe 0

		pipe_00_inst: reg
		generic map(BITDEPTH_L00*DIM*DIM)
		port map(
				D          => ref_readdata((BITDEPTH_L00*DIM*DIM*(i+1))-1 downto (BITDEPTH_L00*DIM*DIM*i)),
				clock      => clock_1_clk,
				enable     => pipe_0,
				sync_reset => sync_reset,
				rst        => reset,
				Q          => y0(i)
			);

		pipe_01_inst: reg
		generic map(BITDEPTH_L00*DIM*DIM)
		port map(
				D          => cur_readdata((BITDEPTH_L00*DIM*DIM*(i+1))-1 downto (BITDEPTH_L00*DIM*DIM*i)),
				clock      => clock_1_clk,
				enable     => pipe_0,
				sync_reset => sync_reset,
				rst        => reset,
				Q          => y1(i)
			);


		DIFF_inst: DIFF
		port map (
				 A0 => y0(i),
				 A1 => y1(i),
				 B  => s0(i)
			 );

		HAD_b_inst: HAD_b
		port map (
				 A => s0(i),
				 B => s1(i)
			 );

-- pipe 1

		pipe_1_inst: reg
		generic map(BITDEPTH_L07*DIM*DIM)
		port map(
				D          => s1(i),
				clock      => clock_1_clk,
				enable     => pipe_1,
				sync_reset => sync_reset,
				rst        => reset,
				Q          => s2(i)
			);


		SAV_inst: SAV
		port map (
				 A => s2(i),
				 B => s3(i)
			 );

		s4(i) <= s3(i)(BITDEPTH_L14-1 downto 2);

-- pipe 2

		pipe_2_inst: reg
		generic map(BITDEPTH_L12)
		port map(
				D          => s4(i),
				clock      => clock_1_clk,
				enable     => pipe_2,
				sync_reset => sync_reset,
				rst        => reset,
				Q          => s5(i)
			);

	end generate datapath_gen;


	add00 : adder
	generic map ( BITDEPTH_L12)
	port map (
			 DATAA  => s5(0),
			 DATAB  => s5(1),
			 RESULT => s6(0)
		 );

	add01 : adder
	generic map ( BITDEPTH_L12)
	port map (
			 DATAA  => s5(2),
			 DATAB  => s5(3),
			 RESULT => s6(1)
		 );

	add03 : adder
	generic map ( BITDEPTH_L13)
	port map (
			 DATAA  => s6(0),
			 DATAB  => s6(1),
			 RESULT => s7(BITDEPTH_L14-1 downto 0)
		 );

	s7(BITDEPTH_L17-1 downto BITDEPTH_L14) <= (others => '0');


	add04 : adder
	generic map ( BITDEPTH_L17)
	port map (
			 DATAA  => s7,
			 DATAB  => s8,
			 RESULT => s9
		 );

	-- pipe 3

	pipe_3_inst: reg
	generic map(BITDEPTH_L17)
	port map(
			D          => s9(BITDEPTH_L17-1 downto 0),
			clock      => clock_1_clk,
			enable     => pipe_3,
			sync_reset => sync_reset,
			rst        => reset,
			Q          => s8
		);


--mux

	MUX_0 : process (SEL, s4(0), s7, s8 )

	begin
		case( SEL ) is
			when "00" =>
				SATD(BITDEPTH_L17-1 downto BITDEPTH_L12) <= (others => '0');
				SATD(BITDEPTH_L12-1 downto 0) <= s4(0);
			when "01" =>
				SATD <= s7;
			when "10" =>
				SATD <= s8;
			when others =>
				SATD <= (others => '0');
		end case ;
	end process ; -- MUX_0

-- pipe enable

	pipe_0 <= P_EN(0) or P_EN(1) or P_EN(2);

	grant_pipe_0: reg
	generic map(3)
	port map(
			D          => P_EN,
			clock      => clock_1_clk,
			enable     => '1',
			sync_reset => sync_reset,
			rst        => reset,
			Q          => P_EN_1
		);

	pipe_1 <= P_EN_1(0) or P_EN_1(1) or P_EN_1(2);

	grant_pipe_1: reg
	generic map(2)
	port map(
			D          => P_EN_1(2 downto 1),
			clock      => clock_1_clk,
			enable     => '1',
			sync_reset => sync_reset,
			rst        => reset,
			Q          => P_EN_2(1 downto 0)
		);

	pipe_2 <= P_EN_2(0) or P_EN_2(1);

	grant_pipe_2: latch_0
	port map(
			D          => P_EN_2(1),
			clock      => clock_1_clk,
			enable     => '1',
			sync_reset => sync_reset,
			rst        => reset,
			Q          => pipe_3
		);



	cur_waitrequest <= ref_write;

	ref_waitrequest <= cur_write;

end behaviour;
