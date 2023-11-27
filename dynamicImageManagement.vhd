LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY dynamicImageManagement IS
	PORT	(	clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				ena_comp	:	IN		STD_LOGIC_VECTOR(	6 DOWNTO 0 );
				x_1		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_1		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_2		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_2		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_3		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_3		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_4		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_4		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_5		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_5		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_6		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_6		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_7		:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_7		:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				wr_en		:	OUT	STD_LOGIC;
				w_addr_j	:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				w_addr_i	:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				w_data	:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF dynamicImageManagement IS

	SIGNAL	w_addr_s_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s		:	STD_LOGIC;
	
	SIGNAL	comp_s_j	:	STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL	comp_s_i	:	STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	
	SIGNAL	max_tick_s	:	STD_LOGIC;

BEGIN

	counterbits_j: ENTITY work.univ_bin_counter
	GENERIC MAP(	N => 4	)
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	'0',
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
					syn_clr	=>	'0',
					load		=>	'0',
					up			=>	'1',
					max		=>	"111",
					d			=>	"000",
					counter	=>	w_addr_s_i);
	
	comp1_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_1,
					sel	=>	'0',
					eq		=>	comp_s_j(0));
	
	comp2_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_2,
					sel	=>	'0',
					eq		=>	comp_s_j(1));
	
	comp3_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_3,
					sel	=>	'0',
					eq		=>	comp_s_j(2));
	
	comp4_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_4,
					sel	=>	'0',
					eq		=>	comp_s_j(3));
	
	comp5_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_5,
					sel	=>	'0',
					eq		=>	comp_s_j(4));
	
	comp6_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_6,
					sel	=>	'0',
					eq		=>	comp_s_j(5));
	
	comp7_j: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	4	)
	PORT MAP(	A		=>	w_addr_s_j,
					B		=>	x_7,
					sel	=>	'0',
					eq		=>	comp_s_j(6));
	
	comp1_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_1,
					sel	=>	'0',
					eq		=>	comp_s_i(0));
	
	comp2_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_2,
					sel	=>	'0',
					eq		=>	comp_s_i(1));
	
	comp3_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_3,
					sel	=>	'0',
					eq		=>	comp_s_i(2));
	
	comp4_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_4,
					sel	=>	'0',
					eq		=>	comp_s_i(3));
	
	comp5_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_5,
					sel	=>	'0',
					eq		=>	comp_s_i(4));
	
	comp6_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_6,
					sel	=>	'0',
					eq		=>	comp_s_i(5));
	
	comp7_i: ENTITY work.nBitComparator
	GENERIC MAP(	nBits	=>	3	)
	PORT MAP(	A		=>	w_addr_s_i,
					B		=>	y_7,
					sel	=>	'0',
					eq		=>	comp_s_i(6));
	
	w_data_s	<=	((comp_s_j(0) AND comp_s_i(0) AND ena_comp(0))
				OR (comp_s_j(1) AND comp_s_i(1) AND ena_comp(1))
				OR (comp_s_j(2) AND comp_s_i(2) AND ena_comp(2))
				OR (comp_s_j(3) AND comp_s_i(3) AND ena_comp(3))
				OR (comp_s_j(4) AND comp_s_i(4) AND ena_comp(4))
				OR (comp_s_j(5) AND comp_s_i(5) AND ena_comp(5))
				OR (comp_s_j(6) AND comp_s_i(6) AND ena_comp(6)));
	
	wr_en		<=	'1';
	w_addr_j	<=	w_addr_s_j;
	w_addr_i	<=	w_addr_s_i;
	w_data	<=	w_data_s;

END ARCHITECTURE;