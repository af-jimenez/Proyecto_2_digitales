LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE my_pkg IS
  FUNCTION conv_slv  ( b : BIT_VECTOR ) RETURN std_logic_vector;
  
  TYPE	img_mtx IS ARRAY (natural range 0 TO 7) OF STD_LOGIC_VECTOR( 15 DOWNTO 0 );
  TYPE	imgs_mtx	IS	ARRAY	(natural range <>)	OF	img_mtx;
END my_pkg;

library altera;
use altera.altera_internal_syn.all;

PACKAGE BODY my_pkg IS
	FUNCTION conv_slv  ( b : BIT_VECTOR ) RETURN std_logic_vector IS
        ALIAS bv : BIT_VECTOR ( b'LENGTH-1 DOWNTO 0 ) IS b;
        VARIABLE result : std_logic_vector ( b'LENGTH-1 DOWNTO 0 );
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "FEED_THROUGH" ;
   BEGIN
        FOR i IN result'RANGE LOOP
            CASE bv(i) IS
                WHEN '0' => result(i) := '0';
                WHEN '1' => result(i) := '1';
            END CASE;
        END LOOP;
        RETURN result;
   END;
END my_pkg;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pkg.ALL;
----------------------------------------
ENTITY main IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				start			:	IN		STD_LOGIC;
				pause			:	IN		STD_LOGIC;
				btn_up_L		:	IN		STD_LOGIC;
				btn_dn_L		:	IN		STD_LOGIC;
				btn_up_R		:	IN		STD_LOGIC;
				btn_dn_R		:	IN		STD_LOGIC;
				score_R		:	OUT	STD_LOGIC_VECTOR( 6 DOWNTO 0 );
				score_L		:	OUT	STD_LOGIC_VECTOR( 6 DOWNTO 0 );
				rows			:	OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				cols			:	OUT	STD_LOGIC_VECTOR( 15 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF main IS

	-- Led Matrix Controller Signals --
	SIGNAL	max_tick_lmc	:	STD_LOGIC;
	SIGNAL	r_addr_lm_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	r_addr_lm_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	r_data_lm		:	STD_LOGIC;
	
	-- Write to Register Signals --
	SIGNAL	w_addr_s_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s			:	STD_LOGIC;
	SIGNAL	wr_en_s			:	STD_LOGIC;
	SIGNAL	w_addr_s1_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s1_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s1		:	STD_LOGIC;
	SIGNAL	wr_en_s1			:	STD_LOGIC;
	SIGNAL	w_addr_s2_j		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_s2_i		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_s2		:	STD_LOGIC;
	SIGNAL	wr_en_s2			:	STD_LOGIC;
	
	-- Speed Control --
	SIGNAL	ballChange		:	STD_LOGIC;
	SIGNAL	ballSpeed		:	STD_LOGIC_VECTOR( 27 DOWNTO 0 );
	
	-- Main FSM Control Signals --
	SIGNAL	max_izq			:	STD_LOGIC;
	SIGNAL	max_der			:	STD_LOGIC;
	SIGNAL	tick_timer_1s	:	STD_LOGIC;
	SIGNAL	tick_timer_3s	:	STD_LOGIC;
	SIGNAL	tick_timer_g	:	STD_LOGIC;
	SIGNAL	tick_timer_w	:	STD_LOGIC;
	SIGNAL	timer_ena_3s	:	STD_LOGIC;
	SIGNAL	timer_ena_g		:	STD_LOGIC;
	SIGNAL	timer_ena_w		:	STD_LOGIC;
	SIGNAL	rst_game			:	STD_LOGIC;
	SIGNAL	goal_sig_1		:	STD_LOGIC;
	SIGNAL	goal_s_1			:	STD_LOGIC;
	SIGNAL	goal_sig_2		:	STD_LOGIC;
	SIGNAL	goal_s_2			:	STD_LOGIC;
	
	-- Start & Pause Button Signals --
	SIGNAL	start_s			:	STD_LOGIC;
	SIGNAL	start_sig		:	STD_LOGIC;
	SIGNAL	pause_s			:	STD_LOGIC;
	SIGNAL	pause_sig		:	STD_LOGIC;
	
	-- Input Management Signals --
	SIGNAL	btn_up_L_s		:	STD_LOGIC;
	SIGNAL	btn_dn_L_s		:	STD_LOGIC;
	SIGNAL	btn_up_R_s		:	STD_LOGIC;
	SIGNAL	btn_dn_R_s		:	STD_LOGIC;
	
	-- Scoring Management Signals --
	SIGNAL	score_Rs			:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	score_Ls			:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	
	-- Ball & Racket Position Signals --
	SIGNAL	x_sel_s			:	STD_LOGIC;
	SIGNAL	y_sel_s			:	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL	x_s				:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_s				:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	next_x_s			:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	next_y_s			:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_L_Ra_s			:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_L_Ra_s			:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_L_Ra_p1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_L_Ra_p1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_L_Ra_m1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_L_Ra_m1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_R_Ra_s			:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_R_Ra_s			:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_R_Ra_p1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_R_Ra_p1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	x_R_Ra_m1		:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	y_R_Ra_m1		:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	ini_s				:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	
	-- Collision Detection Signals --
	-- -- Border Collision -- --
	SIGNAL	col_izq			:	STD_LOGIC;
	SIGNAL	col_der			:	STD_LOGIC;
	SIGNAL	n_col_izq_s		:	STD_LOGIC;
	SIGNAL	n_col_der_s		:	STD_LOGIC;
	SIGNAL	col_pis			:	STD_LOGIC;
	SIGNAL	col_tec			:	STD_LOGIC;
	-- -- Left Racket Collision -- --
	SIGNAL	top_Ra_L_s		:	STD_LOGIC;
	SIGNAL	top_Co_L_s		:	STD_LOGIC;
	SIGNAL	mid_Ra_L_s		:	STD_LOGIC;
	SIGNAL	bot_Ra_L_s		:	STD_LOGIC;
	SIGNAL	bot_Co_L_s		:	STD_LOGIC;
	
	SIGNAL	top_Ra_L			:	STD_LOGIC;
	SIGNAL	top_Co_L			:	STD_LOGIC;
	SIGNAL	mid_Ra_L			:	STD_LOGIC;
	SIGNAL	bot_Ra_L			:	STD_LOGIC;
	SIGNAL	bot_Co_L			:	STD_LOGIC;
	-- -- Right Racket Collision -- --
	SIGNAL	top_Ra_R_s		:	STD_LOGIC;
	SIGNAL	top_Co_R_s		:	STD_LOGIC;
	SIGNAL	mid_Ra_R_s		:	STD_LOGIC;
	SIGNAL	bot_Ra_R_s		:	STD_LOGIC;
	SIGNAL	bot_Co_R_s		:	STD_LOGIC;
	
	SIGNAL	top_Ra_R			:	STD_LOGIC;
	SIGNAL	top_Co_R			:	STD_LOGIC;
	SIGNAL	mid_Ra_R			:	STD_LOGIC;
	SIGNAL	bot_Ra_R			:	STD_LOGIC;
	SIGNAL	bot_Co_R			:	STD_LOGIC;
	--

BEGIN
	
	counterLM: ENTITY work.univ_bin_counter
	GENERIC MAP(	N	=>	14	)
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	rst,
					load		=>	'0',
					up			=>	'1',
					max		=>	"01100101100100", --130u
					d			=>	"00000000000000",
					max_tick	=>	max_tick_lmc);
	
	lmc: ENTITY work.ledMatrixController
	PORT MAP(	rst			=>	rst,
					readyTimer	=>	max_tick_lmc,
					ena			=>	ena,
					led_state	=>	r_data_lm,
					r_addr_j		=>	r_addr_lm_j,
					r_addr_i		=>	r_addr_lm_i,
					rows			=>	rows,
					cols			=>	cols);
	
	reg_lmc: ENTITY work.register_file
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					wr_en		=>	wr_en_s,
					w_addr_i	=>	w_addr_s_i,
					w_addr_j	=>	w_addr_s_j,
					w_data	=>	w_data_s,
					r_addr_i	=>	r_addr_lm_i,
					r_addr_j	=>	r_addr_lm_j,
					r_data	=>	r_data_lm
					);
	
	FSM_control: ENTITY work.main_FSM
	PORT MAP(clk				=>	clk,
				rst				=>	rst,
				ena				=>	ena,
				str_btn			=>	start_sig,
				col_izq			=>	col_izq,
				col_der			=>	col_der,
				max_izq			=>	max_izq,
				max_der			=>	max_der,
				tick_timer_1s	=>	tick_timer_1s,
				tick_timer_3s	=>	tick_timer_3s,
				tick_timer_g	=>	tick_timer_g,
				tick_timer_w	=>	tick_timer_w,
				timer_ena_3s	=>	timer_ena_3s,
				timer_ena_g		=>	timer_ena_g,
				timer_ena_w		=>	timer_ena_w,
				rst_game			=>	rst_game,
				goal_sig_1		=>	goal_sig_1,
				goal_sig_2		=>	goal_sig_2,
				wr_en				=>	wr_en_s1,
				w_addr_i			=>	w_addr_s1_i,
				w_addr_j			=>	w_addr_s1_j,
				w_data			=>	w_data_s1);
	
	pauseEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	pause,
					rise      =>	pause_s);
	
	pauseSt: ENTITY work.mydff_1
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	pause_s,
					prn		=>	'0',
					ini_st	=>	'1',
					d			=>	NOT(pause_sig),
					q			=>	pause_sig);
	
	startEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	start,
					rise      =>	start_s);
	
	startSt: ENTITY work.mydff_1
	PORT MAP(	clk		=>	clk,
					rst		=>	rst,
					ena		=>	start_s,
					prn		=>	'0',
					ini_st	=>	'0',
					d			=>	NOT(start_sig),
					q			=>	start_sig);
	
	scoreR_tally: ENtITY work.univ_bin_counter
	GENERIC MAP(	N	=>	4	)
	PORT MAP(	clk		=>	goal_sig_1,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	rst,
					load		=>	'0',
					up			=>	'1',
					max		=>	"1001",
					d			=>	"0000",
					max_tick	=>	max_der,
					counter	=>	score_Ls);
	
	scoreL_tally: ENtITY work.univ_bin_counter
	GENERIC MAP(	N	=>	4	)
	PORT MAP(	clk		=>	goal_sig_2,
					rst		=>	rst,
					ena		=>	ena,
					syn_clr	=>	rst,
					load		=>	'0',
					up			=>	'1',
					max		=>	"1001",
					d			=>	"0000",
					max_tick	=>	max_izq,
					counter	=>	score_Rs);
	
	time_1s:	ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_3s,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick =>	tick_timer_1s);
	
	time_3s: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 2 )
	PORT	MAP(	clk      =>	tick_timer_1s,
					rst      =>	rst,
					ena      =>	ena,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00",
					max      =>	"11",
					max_tick	=>	tick_timer_3s);
	
	timer_g:	ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_g,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick =>	tick_timer_g);
	
	timer_w:	ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 26 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	timer_ena_w,
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"00000000000000000000000000",
					max      =>	"10111110101111000010000000",
					max_tick =>	tick_timer_w);
	
	btn_L_upEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	btn_up_L,
					rise      =>	btn_up_L_s);
	
	btn_L_dnEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	btn_dn_L,
					rise      =>	btn_dn_L_s);
	
	input_L: ENTITY work.racket_L_position
	PORT MAP(clk      	=>	clk,
				rst      	=>	(rst_game OR rst),
				ena      	=>	(pause_sig AND ena),
				btn_up_L		=>	btn_dn_L_s,
				btn_dn_L		=>	btn_up_L_s,
				x_L_Ra		=>	x_L_Ra_s,
				x_L_Ra_p1	=>	x_L_Ra_p1,
				x_L_Ra_m1	=>	x_L_Ra_m1,
				y_L_Ra		=>	y_L_Ra_s,
				y_L_Ra_p1	=>	y_L_Ra_p1,
				y_L_Ra_m1	=>	y_L_Ra_m1);
	
	btn_R_upEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	btn_up_R,
					rise      =>	btn_up_R_s);
	
	btn_R_dnEdge: ENTITY work.edge_detect
	PORT MAP(	clk       =>	clk,
					async_sig =>	btn_dn_R,
					rise      =>	btn_dn_R_s);
	
	input_R: ENTITY work.racket_R_position
	PORT MAP(clk      	=>	clk,
				rst      	=>	(rst_game OR rst),
				ena      	=>	(pause_sig AND ena),
				btn_up_R		=>	btn_dn_R_s,
				btn_dn_R		=>	btn_up_R_s,
				x_R_Ra		=>	x_R_Ra_s,
				x_R_Ra_p1	=>	x_R_Ra_p1,
				x_R_Ra_m1	=>	x_R_Ra_m1,
				y_R_Ra		=>	y_R_Ra_s,
				y_R_Ra_p1	=>	y_R_Ra_p1,
				y_R_Ra_m1	=>	y_R_Ra_m1);
	
	ballSpeedDecline: ENTITY work.ballSpeed_FSM
	PORT MAP(clk			=>	clk,
				rst			=>	(rst_game OR rst),
				ena			=>	(pause_sig AND ena),
				racketHits	=>	(top_Ra_R OR mid_Ra_R OR bot_Ra_R OR top_Ra_L OR mid_Ra_L OR bot_Ra_L),
				ballSpeed	=>	ballSpeed);
	
	ballTimer: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 28 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	(rst_game OR rst),
					ena      =>	(pause_sig AND ena),
					syn_clr  =>	(rst_game OR rst),
					load     =>	'0',
					up       =>	'1',
					d        =>	"0000000000000000000000000000",
					max      =>	unsigned(ballSpeed),
					max_tick	=>	ballChange);

	sel_st: ENTITY work.univ_bin_counter
	GENERIC MAP(  N => 3 )
	PORT	MAP(	clk      =>	clk,
					rst      =>	rst,
					ena      =>	(pause_sig AND ena),
					syn_clr  =>	rst,
					load     =>	'0',
					up       =>	'1',
					d        =>	"000",
					max      =>	"101",
					counter	=>	ini_s);
	
	xandySelect: ENTITY work.x_yController
	PORT MAP(	clk		=>	clk,
					rst		=>	(rst_game OR rst),
					ena		=>	(pause_sig AND ena),
					en_id		=>	"00",
					col_izq	=>	col_izq,
					col_der	=>	col_der,
					top_R		=>	top_Ra_R,
					top_co_R		=>	top_Co_R,
					mid_R		=>	mid_Ra_R,
					bot_R		=>	bot_Ra_R,
					bot_co_R		=>	bot_Co_R,
					top_L		=>	top_Ra_L,
					top_co_L		=>	top_Co_L,
					mid_L		=>	mid_Ra_L,
					bot_L		=>	bot_Ra_L,
					bot_co_L		=>	bot_Co_L,
					col_pis	=>	col_pis,
					col_tec	=>	col_tec,
					ini_st	=>	ini_s,
					x_sel		=>	x_sel_s,
					y_sel		=>	y_sel_s);
	
	ball_mov: ENTITY work.ball_coor
	PORT MAP	(	clk      	=>	clk,
					rst      	=>	(rst_game OR rst),
					ena      	=>	(pause_sig AND ena),
					en_changes	=>	ballChange,
					x_sel			=>	x_sel_s,
					y_sel			=>	y_sel_s,
					x_b_ini_st	=>	"1000",
					y_b_ini_st	=>	"011",
					x_nball		=>	next_x_s,
					y_nball		=>	next_y_s,
					x_ball		=>	x_s,
					y_ball		=>	y_s);
	
	printElements: ENTITY work.dynamicImageManagement
	PORT MAP(	clk		=>	clk,
					rst		=>	(rst_game OR rst),
					ena		=>	(pause_sig AND ena),
					ena_comp	=>	"1111111",
					x_1		=>	x_s,
					y_1		=>	y_s,
					x_2		=>	x_R_Ra_s,
					y_2		=>	y_R_Ra_s,
					x_3		=>	x_L_Ra_s,
					y_3		=>	y_L_Ra_s,
					x_4		=>	x_R_Ra_p1,
					y_4		=>	y_R_Ra_p1,
					x_5		=>	x_R_Ra_m1,
					y_5		=>	y_R_Ra_m1,
					x_6		=>	x_L_Ra_p1,
					y_6		=>	y_L_Ra_p1,
					x_7		=>	x_L_Ra_m1,
					y_7		=>	y_L_Ra_m1,
					wr_en		=>	wr_en_s2,
					w_addr_j	=>	w_addr_s2_j,
					w_addr_i	=>	w_addr_s2_i,
					w_data	=>	w_data_s2);
	
	der_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x_s,
					B		=>	"1111",
					sel	=>	'0',
					eq		=>	col_der);
	
	izq_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	x_s,
					B		=>	"0000",
					sel	=>	'0',
					eq		=>	col_izq);
	
	der_n_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	next_x_s,
					B		=>	"1111",
					sel	=>	'0',
					eq		=>	n_col_der_s);
	
	izq_n_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 4 )
	PORT MAP(	A		=>	next_x_s,
					B		=>	"0000",
					sel	=>	'0',
					eq		=>	n_col_izq_s);
	
	pis_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	"111",
					sel	=>	'0',
					eq		=>	col_pis);
	
	tec_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	"000",
					sel	=>	'0',
					eq		=>	col_tec);
	
	topR_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_R_Ra_m1,
					sel	=>	'0',
					eq		=>	top_Ra_R_s);
	
	topRcor_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	next_y_s,
					B		=>	y_R_Ra_m1,
					sel	=>	'0',
					eq		=>	top_Co_R_s);
	
	midR_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_R_Ra_s,
					sel	=>	'0',
					eq		=>	mid_Ra_R_s);
	
	botR_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_R_Ra_p1,
					sel	=>	'0',
					eq		=>	bot_Ra_R_s);
	
	botRcor_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	next_y_s,
					B		=>	y_R_Ra_p1,
					sel	=>	'0',
					eq		=>	bot_Co_R_s);
	
	
	
	topL_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_L_Ra_m1,
					sel	=>	'0',
					eq		=>	top_Ra_L_s);
	
	topLcor_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	next_y_s,
					B		=>	y_L_Ra_m1,
					sel	=>	'0',
					eq		=>	top_Co_L_s);
	
	midL_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_L_Ra_s,
					sel	=>	'0',
					eq		=>	mid_Ra_L_s);
	
	botL_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	y_s,
					B		=>	y_L_Ra_p1,
					sel	=>	'0',
					eq		=>	bot_Ra_L_s);
	
	botLcor_coli: ENTITY work.nBitComparator
	GENERIC MAP( nBits => 3 )
	PORT MAP(	A		=>	next_y_s,
					B		=>	y_L_Ra_p1,
					sel	=>	'0',
					eq		=>	bot_Co_L_s);
	
	top_Ra_R	<=	(top_Ra_R_s AND n_col_der_s);
	top_Co_R	<=	(top_Co_R_s AND n_col_der_s);
	mid_Ra_R	<=	(mid_Ra_R_s AND n_col_der_s);
	bot_Ra_R	<=	(bot_Ra_R_s AND n_col_der_s);
	bot_Co_R	<=	(bot_Co_R_s AND n_col_der_s);
	
	top_Ra_L	<=	(top_Ra_L_s AND n_col_izq_s);
	top_Co_L	<=	(top_Co_L_s AND n_col_izq_s);
	mid_Ra_L	<=	(mid_Ra_L_s AND n_col_izq_s);
	bot_Ra_L	<=	(bot_Ra_L_s AND n_col_izq_s);
	bot_Co_L	<=	(bot_Co_L_s AND n_col_izq_s);
	
	scoreR_sseg: ENTITY work.bin_to_sseg
	PORT MAP(bin	=>	score_Rs,
				sseg	=>	score_R);
	
	scoreL_sseg: ENTITY work.bin_to_sseg
	PORT MAP(bin	=>	score_Ls,
				sseg	=>	score_L);
	
	ss: ENTITY work.signalSelector
	PORT MAP(clk			=>	clk,
				rst			=>	rst,
				game_sig		=>	rst_game,
				wr_en_s1		=>	wr_en_s1,
				w_addr_s1_i	=>	w_addr_s1_i,
				w_addr_s1_j	=>	w_addr_s1_j,
				w_data_s1	=>	w_data_s1,
				wr_en_s2		=>	wr_en_s2,
				w_addr_s2_i	=>	w_addr_s2_i,
				w_addr_s2_j	=>	w_addr_s2_j,
				w_data_s2	=>	w_data_s2,
				wr_en			=>	wr_en_s,
				w_addr_j		=>	w_addr_s_j,
				w_addr_i		=>	w_addr_s_i,
				w_data		=>	w_data_s);
	
END ARCHITECTURE;