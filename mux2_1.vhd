LIBRARY IEEE;
USE ieee.std_logic_1164.all;
--------------------------------------
ENTITY mux2_1 IS
	
	GENERIC(	N	:	INTEGER	:=	4	);
	PORT(	X1		:	IN		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			X2		:	IN		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			sel	:	IN		STD_LOGIC;
			Y		:	OUT	STD_LOGIC_VECTOR(N-1 DOWNTO 0));
			
END ENTITY;
--------------------------------------
ARCHITECTURE functional OF mux2_1 IS
--------------------------------------
BEGIN

	WITH sel SELECT
		Y	<=	X1	WHEN	'0',
				X2	WHEN	OTHERS;
	
END ARCHITECTURE;