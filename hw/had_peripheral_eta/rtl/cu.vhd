library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.type_def.all;                   

entity CONTROL_UNIT is
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
		clock_1_clk      : in  std_logic 								-- 50MHz
);
end CONTROL_UNIT;

architecture RTL of CONTROL_UNIT is

	type State_type IS (R, B, C, D, E, F, G);
	signal State                              : State_Type;

	signal ctrl_register                      : std_logic_vector(3 downto 0)             := "0000";
	signal r_enable                           : std_logic_vector(sram_units-1 downto 0);
	signal p_enable                           : std_logic_vector(2 downto 0);

	signal SATD_out                           : std_logic_vector(31 downto 0);

	signal clock_cycles                       : natural range 0 to sram_loc-1;
	signal inc_cnt                            : natural range 0 to sram_loc+3-1;

begin 
	process (clock_1_clk, reset) 
	begin 
		if (reset = '1') then  
			State <= R;

		elsif rising_edge(clock_1_clk) then
			case State is

				when R =>  
					State <= B;
					inc_cnt <= 0;

				when B => 
					inc_cnt <= 0;
					if (res_read ='1') then 
						State <= C;
					else 
						State <= B;
					end if; 

				when C => 
					if (res_read ='1') then
						if ctrl_register = "0000" or ctrl_register = "0001" or ctrl_register = "0100" then
							State <= D;
							inc_cnt <= inc_cnt+1;
						elsif ctrl_register = "0010" or ctrl_register = "0011" or ctrl_register = "0110" or ctrl_register = "0101" or ctrl_register = "0111" or ctrl_register = "1000" then
							State <= E;
							inc_cnt <= inc_cnt+1;
						else
							State <= B;
						end if;
					else 
						State <= B;
					end if; 

				when D => 
					if (res_read ='1') then
						if inc_cnt = clock_cycles then 
							State <= G;
						else
							State <= D;
							inc_cnt <= inc_cnt+1;
						end if;
					else 
						State <= B;
					end if; 

				when E =>
					if (res_read ='1') then 										-- 32x32 and 64x64
						if inc_cnt = clock_cycles then 
							State <= F;
							inc_cnt <= inc_cnt+1;
						else
							State <= E;
							inc_cnt <= inc_cnt+1;
						end if;
					else 
						State <= B;
					end if;

				when F => 
					if (res_read ='1') then											-- 32x32 and 64x64
						if inc_cnt = clock_cycles+3 then 
							State <= G;
						else
							State <= F;
							inc_cnt <= inc_cnt+1;
						end if;
					else 
						State <= B;
					end if;

				when G => 
					if res_read = '0' then 
						State <= B; 
					else 
						State <= G; 
					end if; 

				when others =>
					State <= B;
			end case; 
		end if; 
	end process;

	sync_reset                        <= '1'      when State=R or State=B else '0';
	ctrl_waitrequest                  <= '0'      when State=B else '1';
	res_readdata                      <= SATD_out when State=G else (others => '0');
	res_waitrequest                   <= '0'      when State=G else '1';
	P_EN                              <= p_enable when State=C or State=E else "000";

	rd_address                        <= std_logic_vector(to_unsigned(inc_cnt+1, rd_address'length)) when State=C or State=E else (others => '0');

	rd_enable                         <= r_enable;

	SATD_out(BITDEPTH_L17-1 downto 0) <= SATD_i;
	SATD_out(31 downto BITDEPTH_L17)  <= (others => '0');

	CTRLP : process (clock_1_clk, reset, ctrl_writedata, ctrl_write)
	begin

		if reset = '1' then
			ctrl_register <= "0000";
		elsif clock_1_clk'event and clock_1_clk = '1' then
			if (ctrl_write = '1') then
				ctrl_register <= ctrl_writedata(3 downto 0);
			else
				ctrl_register <= ctrl_register;
			end if;
		end if;
	end process ; -- CTRLP

	LUT_proc: process(ctrl_register)
	begin
		case ctrl_register is
			when "0000" => 		--8x8
				clock_cycles <= 1;
				SEL <= "00";
				p_enable <= "001";
				r_enable <= "0000000000001111";
			when "0001" => 		--16x16 --32x8
				clock_cycles <= 2;
				SEL <= "01";
				p_enable <= "010";
				r_enable <= "1111111111111111";
			when "0010" => 		--32x32 --64x16
				clock_cycles <= 3;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";
			when "0011" => 		--64x64
				clock_cycles <= 15;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";

			when "0100" =>		--16x8
				clock_cycles <= 2;
				SEL <= "01";
				p_enable <= "010";
				r_enable <= "0000000011111111";
			when "0101" =>		--32x16
				clock_cycles <= 1;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";
			when "0110" =>		--32x24
				clock_cycles <= 2;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";
			when "0111" =>		--64x32
				clock_cycles <= 7;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";
			when "1000" =>		--64x48
				clock_cycles <= 11;
				SEL <= "10";
				p_enable <= "100";
				r_enable <= "1111111111111111";

			when others =>
				clock_cycles <= 1;
				SEL <= "00";
				p_enable <= "000";
				r_enable <= "0000000000000000";
		end case;
	end process;

end rtl;
