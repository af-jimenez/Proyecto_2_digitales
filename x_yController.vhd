LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
----------------------------------------
ENTITY x_yController IS
	PORT	(	clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				en_id		:	IN		STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				col_izq	:	IN		STD_LOGIC;
				col_der	:	IN		STD_LOGIC;
				top_R		:	IN		STD_LOGIC;
				top_co_R	:	IN		STD_LOGIC;
				mid_R		:	IN		STD_LOGIC;
				bot_r		:	IN		STD_LOGIC;
				bot_co_r	:	IN		STD_LOGIC;
				top_L		:	IN		STD_LOGIC;
				top_co_L	:	IN		STD_LOGIC;
				mid_L		:	IN		STD_LOGIC;
				bot_L		:	IN		STD_LOGIC;
				bot_co_L	:	IN		STD_LOGIC;
				col_pis	:	IN		STD_LOGIC;
				col_tec	:	IN		STD_LOGIC;
				ini_st	:	IN		STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				x_sel		:	OUT	STD_LOGIC;
				y_sel		:	OUT	STD_LOGIC_VECTOR( 1 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF x_yController IS

	SIGNAL	col_izq_s	:	STD_LOGIC;
	SIGNAL	col_der_s	:	STD_LOGIC;

	TYPE state IS (st0, st1, st2, st3, st4, st5);
	SIGNAL pr_state, nx_state	:	state;
	
BEGIN

	col_izq_s	<=	col_der AND en_id(0);
	col_der_s	<=	col_izq AND en_id(1);
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, ini_st, clk)
	BEGIN
		IF (rst = '1') THEN
			IF	(ini_st = "000") THEN
				pr_state	<=	st1;
			ELSIF	(ini_st = "001") THEN
				pr_state	<=	st1;
			ELSIF	(ini_st = "010") THEN
				pr_state	<=	st2;
			ELSIF	(ini_st = "011") THEN
				pr_state	<=	st3;
			ELSIF	(ini_st = "100") THEN
				pr_state	<=	st4;
			ELSE
				pr_state	<=	st1;
			END IF;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(pr_state, col_izq_s, col_der_s, col_pis, col_tec, top_R, top_co_R, mid_R, bot_R, bot_co_R, top_L, top_co_L, mid_L, bot_L, bot_co_L, x_sel, y_sel)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				y_sel	<=	"00";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR mid_L = '1') THEN
					nx_state	<= st5;
				ELSIF (top_L = '1') THEN
					nx_state	<= st1;
				ELSIF (bot_L = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				y_sel	<=	"10";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR top_R = '1') THEN
					nx_state	<= st2;
				ELSIF (mid_R = '1') THEN
					nx_state	<= st0;
				ELSIF (bot_R = '1' OR ((NOT(top_R OR mid_R OR bot_R) AND bot_co_R) = '1')) THEN
					nx_state	<= st4;
				ELSIF (col_tec = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st1;
				END IF;
			WHEN st2	=>
				y_sel	<=	"10";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR top_L = '1') THEN
					nx_state	<= st1;
				ELSIF (mid_L = '1') THEN
					nx_state	<= st5;
				ELSIF (bot_L = '1' OR ((NOT(top_L OR mid_L OR bot_L) AND bot_co_L) = '1')) THEN
					nx_state	<= st3;
				ELSIF (col_tec = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st2;
				END IF;
			WHEN st3	=>
				y_sel	<=	"01";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR bot_R = '1') THEN
					nx_state	<= st4;
				ELSIF (top_R = '1' OR ((NOT(top_R OR mid_R OR bot_R) AND top_co_R) = '1')) THEN
					nx_state	<= st2;
				ELSIF (mid_R = '1') THEN
					nx_state	<= st0;
				ELSIF (col_pis = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st3;
				END IF;
			WHEN st4	=>
				y_sel	<=	"01";
				x_sel	<=	'1';
				IF (col_izq_s = '1' OR bot_L = '1') THEN
					nx_state	<= st3;
				ELSIF (top_L = '1' OR ((NOT(top_L OR mid_L OR bot_L) AND top_co_L) = '1')) THEN
					nx_state	<= st1;
				ELSIF (mid_L = '1') THEN
					nx_state	<= st5;
				ELSIF (col_pis = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st4;
				END IF;
			WHEN st5	=>
				y_sel	<=	"00";
				x_sel	<=	'0';
				IF (col_der_s = '1' OR mid_R = '1') THEN
					nx_state	<= st0;
				ELSIF (top_R = '1') THEN
					nx_state	<= st2;
				ELSIF (bot_R = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st5;
				END IF;
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;