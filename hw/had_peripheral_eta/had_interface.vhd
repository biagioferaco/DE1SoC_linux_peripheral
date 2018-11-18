-- had_interface.vhd

-- This file was auto-generated as a prototype implementation of a module
-- created in component editor.  It ties off all outputs to ground and
-- ignores all inputs.  It needs to be edited to make it do something
-- useful.
--
-- This file will not be automatically regenerated.  You should check it in
-- to your version control system if you want to keep it.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.type_def.all;

entity had_interface is
	port (
		     reset_reset      : in  std_logic                                  := '0';             --   reset.reset
		     cur_address      : in  std_logic_vector(7 downto 0)               := (others => '0'); -- cur.address
		     cur_write        : in  std_logic                                  := '0';             --.write
		     cur_writedata    : in  std_logic_vector(127 downto 0)             := (others => '0'); --.writedata
		     cur_waitrequest  : out std_logic;                                                      --.waitrequest
		     clock_0_clk      : in  std_logic                                  := '0';             -- clock_0.clk
		     clock_1_clk      : in  std_logic                                  := '0';             -- clock_1.clk
		     ref_address      : in  std_logic_vector(7 downto 0)               := (others => '0'); -- ref.address
		     ref_write        : in  std_logic                                  := '0';             --.write
		     ref_writedata    : in  std_logic_vector(127 downto 0)             := (others => '0'); --.writedata
		     ref_waitrequest  : out std_logic;                                                      --.waitrequest
		     ctrl_write       : in  std_logic                                  := '0';             --ctrl.write
		     ctrl_writedata   : in  std_logic_vector(7 downto 0)               := (others => '0'); --.writedata
		     ctrl_waitrequest : out std_logic;                                                      --.waitrequest
		     res_read         : in  std_logic                                  := '0';             -- res.read
		     res_readdata     : out std_logic_vector(31 downto 0);                                  --.readdata
		     res_waitrequest  : out std_logic                                                       --.waitrequest
	     );
end entity had_interface;

architecture rtl of had_interface is

	component CONTROL_UNIT is
		port (
			     ctrl_write       : in  std_logic;
			     ctrl_writedata   : in  std_logic_vector(7 downto 0);
			     ctrl_waitrequest : out std_logic;

			     res_read         : in  std_logic;
			     res_readdata     : out std_logic_vector(31 downto 0);
			     res_waitrequest  : out std_logic;

			     rd_address       : out std_logic_vector(sram_loc_b-1 downto 0);
			     rd_enable        : out std_logic_vector(sram_units-1 downto 0);

			     SATD_i           : in  std_logic_vector(BITDEPTH_L17-1 downto 0);

			     SEL              : out std_logic_vector(1 downto 0);
			     P_EN             : out std_logic_vector(2 downto 0);

			     reset            : in  std_logic;
			     sync_reset       : out std_logic;
			     clock_1_clk      : in  std_logic                                               -- 50MHz
		     );

    end component;

    component DATAPATH is
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
			 clock_0_clk     : in  std_logic;  							-- 100MHz
			 clock_1_clk     : in  std_logic 							-- 50MHz

		 );

    end component;

    signal rd_address : std_logic_vector(sram_loc_b-1 downto 0);
    signal rd_enable  : std_logic_vector(sram_units-1 downto 0);
    signal SEL        : std_logic_vector(1 downto 0);
    signal P_EN       : std_logic_vector(2 downto 0);
    signal SATD       : std_logic_vector(BITDEPTH_L17-1 downto 0);
    signal sync_reset : std_logic;

begin

	CU_0 : CONTROL_UNIT
	port map (
			 ctrl_write       => ctrl_write,
			 ctrl_writedata   => ctrl_writedata,
			 ctrl_waitrequest => ctrl_waitrequest,
			 res_read         => res_read,
			 res_readdata     => res_readdata,
			 res_waitrequest  => res_waitrequest,
			 rd_address       => rd_address,
			 rd_enable        => rd_enable,
			 SATD_i           => SATD,
			 SEL              => SEL,
			 P_EN             => P_EN,
			 reset            => reset_reset,
			 sync_reset       => sync_reset,
			 clock_1_clk      => clock_1_clk
		 );

	DP_0 : DATAPATH
	port map (
			 cur_write       => cur_write,
			 cur_writedata   => cur_writedata,
			 cur_waitrequest => cur_waitrequest,
			 cur_address     => cur_address,
			 ref_write       => ref_write,
			 ref_writedata   => ref_writedata,
			 ref_waitrequest => ref_waitrequest,
			 ref_address     => ref_address,
			 rd_address      => rd_address,
			 rd_enable       => rd_enable,
			 SEL             => SEL,
			 P_EN            => P_EN,
			 SATD            => SATD,
			 reset           => reset_reset,
			 sync_reset      => sync_reset,
			 clock_0_clk     => clock_0_clk,
			 clock_1_clk     => clock_1_clk
		 );

end architecture rtl; -- of had_interface
