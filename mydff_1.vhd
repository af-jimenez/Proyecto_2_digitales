LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
----------------------------------------
ENTITY mydff_1 IS
	PORT	(	clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				prn		:	IN		STD_LOGIC;
				ini_st	:	IN		STD_LOGIC;
				d			:	IN		STD_LOGIC;
				q			:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE rtl OF mydff_1 IS
BEGIN

	dff: PROCESS(clk, rst, prn, ini_st, d)
	BEGIN
		IF (rst = '1')	THEN
			IF	(prn = '0')	THEN
				q	<=	ini_st;
			ELSE
				q	<=	'0';
			END IF;
		ELSIF	(rising_edge(clk)) THEN
			IF	(ena	=	'1') THEN
				q	<=	d;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;