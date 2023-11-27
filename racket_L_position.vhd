LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pkg.ALL;
----------------------------------------
ENTITY racket_L_position IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				ena			:	IN		STD_LOGIC;
				btn_up_L		:	IN		STD_LOGIC;
				btn_dn_L		:	IN		STD_LOGIC;
				x_L_Ra		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				x_L_Ra_p1	:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				x_L_Ra_m1	:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				y_L_Ra		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				y_L_Ra_p1	:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				y_L_Ra_m1	:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF racket_L_position IS

	TYPE state IS (st0, st1, st2, st3, st4, st5);
	SIGNAL pr_state, nx_state	:	state;
	
BEGIN
	
	x_L_Ra	<=	"0000";
	x_L_Ra_p1	<=	"0000";
	x_L_Ra_m1	<=	"0000";
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, clk)
	BEGIN
		IF (rst = '1') THEN
			pr_state	<=	st3;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(btn_up_L, btn_dn_L)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				
				y_L_Ra_p1	<=	"010";
				y_L_Ra		<=	"001";
				y_L_Ra_m1	<=	"000";
				
				IF (btn_up_L = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				
				y_L_Ra_p1	<=	"011";
				y_L_Ra		<=	"010";
				y_L_Ra_m1	<=	"001";
				
				IF (btn_up_L = '1') THEN
					nx_state	<= st2;
				ELSIF (btn_dn_L = '1') THEN
					nx_state	<= st0;
				ELSE
					nx_state	<= st1;
				END IF;
			WHEN st2	=>
				
				y_L_Ra_p1	<=	"100";
				y_L_Ra		<=	"011";
				y_L_Ra_m1	<=	"010";
				
				IF (btn_up_L = '1') THEN
					nx_state	<= st3;
				ELSIF (btn_dn_L = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st2;
				END IF;
				
			WHEN st3	=>
				
				y_L_Ra_p1	<=	"101";
				y_L_Ra		<=	"100";
				y_L_Ra_m1	<=	"011";
				
				IF (btn_up_L = '1') THEN
					nx_state	<= st4;
				ELSIF (btn_dn_L = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st3;
				END IF;
				
			WHEN st4	=>
				
				y_L_Ra_p1	<=	"110";
				y_L_Ra		<=	"101";
				y_L_Ra_m1	<=	"100";
				
				IF (btn_up_L = '1') THEN
					nx_state	<= st5;
				ELSIF (btn_dn_L = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st4;
				END IF;
			WHEN st5	=>
				
				y_L_Ra_p1	<=	"111";
				y_L_Ra		<=	"110";
				y_L_Ra_m1	<=	"101";
				
				IF (btn_dn_L = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st5;
				END IF;
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;