library ieee;
use ieee.std_logic_1164.all;

entity had_peripheral is
	port (

		     HPS_DDR3_ADDR    : out   std_logic_vector(14 downto 0);
		     HPS_DDR3_BA      : out   std_logic_vector(2 downto 0);
		     HPS_DDR3_CAS_N   : out   std_logic;
		     HPS_DDR3_CK_N    : out   std_logic;
		     HPS_DDR3_CK_P    : out   std_logic;
		     HPS_DDR3_CKE     : out   std_logic;
		     HPS_DDR3_CS_N    : out   std_logic;
		     HPS_DDR3_DM      : out   std_logic_vector(3 downto 0);
		     HPS_DDR3_DQ      : inout std_logic_vector(31 downto 0);
		     HPS_DDR3_DQS_N   : inout std_logic_vector(3 downto 0);
		     HPS_DDR3_DQS_P   : inout std_logic_vector(3 downto 0);
		     HPS_DDR3_ODT     : out   std_logic;
		     HPS_DDR3_RAS_N   : out   std_logic;
		     HPS_DDR3_RESET_N : out   std_logic;
		     HPS_DDR3_RZQ     : in    std_logic;
		     HPS_DDR3_WE_N    : out   std_logic;
		     CLOCK_50         : in    std_logic
	     ) ;
end entity ; -- had_peripheral

architecture rtl of had_peripheral is

component system is
		port (
			memory_mem_a       : out   std_logic_vector(14 downto 0);                               -- mem_a
			memory_mem_ba      : out   std_logic_vector(2 downto 0);                                -- mem_ba
			memory_mem_ck      : out   std_logic;                                                   -- mem_ck
			memory_mem_ck_n    : out   std_logic;                                                   -- mem_ck_n
			memory_mem_cke     : out   std_logic;                                                   -- mem_cke
			memory_mem_cs_n    : out   std_logic;                                                   -- mem_cs_n
			memory_mem_ras_n   : out   std_logic;                                                   -- mem_ras_n
			memory_mem_cas_n   : out   std_logic;                                                   -- mem_cas_n
			memory_mem_we_n    : out   std_logic;                                                   -- mem_we_n
			memory_mem_reset_n : out   std_logic;                                                   -- mem_reset_n
			memory_mem_dq      : inout std_logic_vector(31 downto 0)           := (others => 'X'); -- mem_dq
			memory_mem_dqs     : inout std_logic_vector(3 downto 0)            := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n   : inout std_logic_vector(3 downto 0)            := (others => 'X'); -- mem_dqs_n
			memory_mem_odt     : out   std_logic;                                                   -- mem_odt
			memory_mem_dm      : out   std_logic_vector(3 downto 0);                                -- mem_dm
			memory_oct_rzqin   : in    std_logic                                  := 'X';          -- oct_rzqin
			clk_clk            : in    std_logic                                  := 'X'           -- clk
		);
  end component system;

begin

	u0 : component system
	port map (
			 memory_mem_a       => HPS_DDR3_ADDR(14 downto 0),
			 memory_mem_ba      => HPS_DDR3_BA,
			 memory_mem_ck      => HPS_DDR3_CK_P,
			 memory_mem_ck_n    => HPS_DDR3_CK_N,
			 memory_mem_cke     => HPS_DDR3_CKE,
			 memory_mem_cs_n    => HPS_DDR3_CS_N,
			 memory_mem_ras_n   => HPS_DDR3_RAS_N,
			 memory_mem_cas_n   => HPS_DDR3_CAS_N,
			 memory_mem_we_n    => HPS_DDR3_WE_N,
			 memory_mem_reset_n => HPS_DDR3_RESET_N,
			 memory_mem_dq      => HPS_DDR3_DQ(31 downto 0),
			 memory_mem_dqs     => HPS_DDR3_DQS_P(3 downto 0),
			 memory_mem_dqs_n   => HPS_DDR3_DQS_N(3 downto 0),
			 memory_mem_odt     => HPS_DDR3_ODT,
			 memory_mem_dm      => HPS_DDR3_DM(3 downto 0),
			 memory_oct_rzqin   => HPS_DDR3_RZQ,
			 clk_clk            => CLOCK_50
		 );

end architecture ; -- rtl
