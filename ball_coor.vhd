LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY ball_coor IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				en_changes	:	IN		STD_LOGIC;
				x_sel			:	IN		STD_LOGIC;
				y_sel			:	IN		STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				x_b_ini_st	:	IN		STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_b_ini_st	:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_nball		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_nball		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_ball		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_ball		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 ));
END ball_coor;
----------------------------------------
ARCHITECTURE arch OF ball_coor IS

	SIGNAL	x_next_s	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s_p1	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	x_s_m1	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	
	SIGNAL	y_next_s	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s_p1	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	y_s_m1	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	SIGNAL	en_s		:	STD_LOGIC;
	
----------------------------------------
BEGIN
	
	en_s		<=	en_changes;
	
	mux_x: ENTITY work.mux2_1
	GENERIC MAP(	N	=>	4	)
	PORT MAP(	X1		=>	x_s_p1,
					X2		=>	x_s_m1,
					sel	=>	x_sel,
					Y		=>	x_next_s);
	
	dff_x: ENTITY work.mydff
	GENERIC MAP(	N => 4 )
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	en_s,
					prn		=>	'0',
					ini_st	=>	x_b_ini_st,
					d			=>	x_next_s,
					q			=>	x_s);
	
	x_s_p1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(x_s))+1), x_s_p1'length));
	x_s_m1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(x_s))-1), x_s_m1'length));
	
	x_nball	<=	x_next_s;
	x_ball	<=	x_s;
	
	mux_y: ENTITY work.mux4_1
	GENERIC MAP(	N	=>	3	)
	PORT MAP(	X1		=>	y_s,
					X2		=>	y_s_p1,
					X3		=>	y_s_m1,
					X4		=>	y_s,
					sel	=>	y_sel,
					Y		=>	y_next_s);
	
	dff_y: ENTITY work.mydff
	GENERIC MAP(	N => 3 )
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	en_s,
					prn		=>	'0',
					ini_st	=>	y_b_ini_st,
					d			=>	y_next_s,
					q			=>	y_s);
	
	y_s_p1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(y_s))+1), y_s_p1'length));
	y_s_m1	<=	std_logic_vector(to_unsigned((to_integer(unsigned(y_s))-1), y_s_m1'length));
	
	y_nball	<=	y_next_s;
	y_ball	<=	y_s;

END ARCHITECTURE;