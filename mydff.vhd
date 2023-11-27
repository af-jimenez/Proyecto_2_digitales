LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
----------------------------------------
ENTITY mydff IS
	GENERIC	(	N	:	INTEGER	:=	4);
	PORT	(	clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				ena		:	IN		STD_LOGIC;
				prn		:	IN		STD_LOGIC;
				ini_st	:	IN		STD_LOGIC_VECTOR(	N-1 DOWNTO 0 );
				d			:	IN		STD_LOGIC_VECTOR(	N-1 DOWNTO 0 );
				q			:	OUT	STD_LOGIC_VECTOR(	N-1 DOWNTO 0 ));
END ENTITY;
----------------------------------------
ARCHITECTURE rtl OF mydff IS

	SIGNAL	zeros	:	STD_LOGIC_VECTOR( N-1 DOWNTO 0 )	:=	(OTHERS => '0');
	

BEGIN
	
	zeros	<=	(OTHERS => '0');
	
	dff: PROCESS(clk, rst, prn, ini_st, zeros, d)
	BEGIN
		IF (rst = '1')	THEN
			IF	(prn = '0')	THEN
				q	<=	ini_st;
			ELSE
				q	<=	zeros;
			END IF;
		ELSIF	(rising_edge(clk)) THEN
			IF	(ena	=	'1') THEN
				q	<=	d;
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE;