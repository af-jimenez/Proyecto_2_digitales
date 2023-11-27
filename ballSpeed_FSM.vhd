LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pkg.ALL;
----------------------------------------
ENTITY ballSpeed_FSM IS
	PORT	(	clk				:	IN		STD_LOGIC;
				rst				:	IN		STD_LOGIC;
				ena				:	IN		STD_LOGIC;
				racketHits		:	IN		STD_LOGIC;
				ballSpeed		:	OUT	STD_LOGIC_VECTOR( 27 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF ballSpeed_FSM IS

	TYPE state IS (st0, st1, st2, st3, st4, st5, st6, st7, st8, st9);
	SIGNAL nx_state	:	state;
	SIGNAL pr_state	:	state;
	
BEGIN
	
	-------------------------------------------------------------
	--                 LOWER SECTION OF FSM                    --
	-------------------------------------------------------------
	sequential: PROCESS(rst, clk)
	BEGIN
		IF (rst = '1') THEN
			pr_state	<=	st0;
		ELSIF (rising_edge(clk)) THEN
			pr_state	<=	nx_state;
		END IF;
	END PROCESS sequential;
	
	-------------------------------------------------------------
	--                 UPPER SECTION OF FSM                    --
	-------------------------------------------------------------
	combinational: PROCESS(racketHits)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				
				ballSpeed	<=	"0001011111010111100001000000";--0.50s
				
				IF (racketHits = '1') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				
				ballSpeed	<=	"0001010101110101001010100000";--0.45s
				
				IF (racketHits = '1') THEN
					nx_state	<= st2;
				ELSE
					nx_state	<= st1;
				END IF;
			WHEN st2	=>
				
				ballSpeed	<=	"0001001100010010110100000000";--0.40s
				
				IF (racketHits = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st2;
				END IF;
				
			WHEN st3	=>
				
				ballSpeed	<=	"0001000010110000011101100000";--0.35s
					
				IF (racketHits = '1') THEN
					nx_state	<= st4;
				ELSE
					nx_state	<= st3;
				END IF;
				
			WHEN st4	=>
				
				ballSpeed	<=	"0000111001001110000111000000";--0.30s
				
				IF (racketHits = '1') THEN
					nx_state	<= st5;
				ELSE
					nx_state	<= st4;
				END IF;
				
			WHEN st5	=>
				
				ballSpeed	<=	"0000101111101011110000100000";--0.25s
				
				IF (racketHits = '1') THEN
					nx_state	<= st6;
				ELSE
					nx_state	<= st5;
				END IF;
			
			WHEN st6	=>
				
				ballSpeed	<=	"0000100110001001011010000000";--0.20s
					
				IF (racketHits = '1') THEN
					nx_state	<= st7;
				ELSE
					nx_state	<= st6;
				END IF;
				
			WHEN st7	=>
				
				ballSpeed	<=	"0000011100100111000011100000";--0.15s
				
				IF (racketHits = '1') THEN
					nx_state	<= st8;
				ELSE
					nx_state	<= st7;
				END IF;
				
			WHEN st8	=>
				
				ballSpeed	<=	"0000010011000100101101000000";--0.10s
				
				IF (racketHits = '1') THEN
					nx_state	<= st9;
				ELSE
					nx_state	<= st8;
				END IF;
			
			WHEN st9	=>
				
				ballSpeed	<=	"0000001001100010010110100000";--0.05s
				
				nx_state	<= st9;
				
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;