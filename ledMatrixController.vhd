LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY ledMatrixController IS
	PORT	(	rst			:	IN		STD_LOGIC;
				readyTimer	:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				led_state	:	IN		STD_LOGIC;
				r_addr_j		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				r_addr_i		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				rows			:	OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				cols			:	OUT	STD_LOGIC_VECTOR( 15 DOWNTO 0 ));
END ledMatrixController;
----------------------------------------
ARCHITECTURE arch OF ledMatrixController IS

	SIGNAL	max_counter_1	:	STD_LOGIC;
	
	SIGNAL	j_s	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	i_s	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	SIGNAL	rows_s	:	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL	cols_s	:	STD_LOGIC_VECTOR( 15 DOWNTO 0 );
BEGIN

	r_addr_i <= i_s;
	r_addr_j <= j_s;

	counterj: ENTITY work.univ_bin_counter
	GENERIC MAP(	N	=>	4	)
	PORT MAP(	clk		=>	readyTimer,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	'0',
					load		=>	'0',
					up			=>	'1',
					max		=>	"1111",
					d			=>	"0000",
					max_tick	=>	max_counter_1,
					counter	=>	j_s);
	
	counteri: ENTITY work.univ_bin_counter
	GENERIC MAP(	N	=>	3	)
	PORT MAP(	clk		=>	max_counter_1,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	'0',
					load		=>	'0',
					up			=>	'1',
					max		=>	"111",
					d			=>	"000",
					counter	=>	i_s);
	
	decoderi: ENTITY work.decoder3_8
	PORT MAP(	x	=>	i_s,
					en	=>	ena,
					y	=>	rows_s);
	
	rows	<=	NOT(rows_s);
	
	decoderj: ENTITY work.decoder4_16
	PORT MAP(	x	=>	j_s,
					en	=>	led_state,
					y	=>	cols);
		
END ARCHITECTURE;