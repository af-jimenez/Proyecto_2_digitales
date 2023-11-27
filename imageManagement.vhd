LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pkg.ALL;
----------------------------------------
ENTITY imageManagement IS
	PORT	(	clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				imageIn	:	IN		img_mtx;
				wr_en		:	OUT	STD_LOGIC;
				w_addr_j	:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				w_addr_i	:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				w_data	:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF imageManagement IS

	SIGNAL	w_addr_s_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	SIGNAL	max_tick_s	:	STD_LOGIC;
	SIGNAL	clk_s	:	STD_LOGIC;

BEGIN

	counterbits_j: ENTITY work.univ_bin_counter
	GENERIC MAP(	N => 4	)
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	rst,
					load		=>	'0',
					up			=>	'1',
					max		=>	"1111",
					d			=>	"0000",
					max_tick	=>	max_tick_s,
					counter	=>	w_addr_s_j);
	
	counterbits_i: ENTITY work.univ_bin_counter
	GENERIC MAP(	N => 3	)
	PORT MAP(	clk		=>	max_tick_s,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	rst,
					load		=>	'0',
					up			=>	'1',
					max		=>	"111",
					d			=>	"000",
					counter	=>	w_addr_s_i);
	
	wr_en		<=	'1';
	w_addr_j	<=	w_addr_s_j;
	w_addr_i	<=	w_addr_s_i;
	w_data	<=	imageIn(to_integer(unsigned(w_addr_s_i)))(to_integer(unsigned(w_addr_s_j)));

END ARCHITECTURE;