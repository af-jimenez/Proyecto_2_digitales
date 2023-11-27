-------------------------------------------------
-- THIS IS THE TOP-LEVEL ENTITY                --
--	DESCRIPTION: Converts 2 coded inputs into	  --
--	4 coded outputs		     						  --
--															  --
-- CREATOR: SebastiÃ¡n Gallardo	              --
-- OWNER: SebastiÃ¡n Gallardo						  --
-------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
-------------------------------------------------
ENTITY nBitComparator IS
	GENERIC (
				nBits	:	INTEGER	:=	2
				);
	PORT (
			-- INPUTS
			A		:	IN		STD_LOGIC_VECTOR(nBits-1 DOWNTO 0);
			B		:	IN		STD_LOGIC_VECTOR(nBits-1 DOWNTO 0);
			sel	:	IN		STD_LOGIC;
			-- OUTPUTS
			eq		: 	OUT	STD_LOGIC;
			lg		: 	OUT	STD_LOGIC;
			ls		: 	OUT	STD_LOGIC
			);
END ENTITY nBitComparator;
-------------------------------------------------
ARCHITECTURE functional OF nBitComparator IS
-------------------------------------------------
BEGIN

	--============================================
	eq	<=	'1' WHEN	(	(	SIGNED(A)=SIGNED(B)		)	AND	sel='1'	)	ELSE
			'1' WHEN	(	(	UNSIGNED(A)=UNSIGNED(B)	)	AND	sel='0'	)	ELSE
			'0';
	lg	<=	'1' WHEN	(	(	SIGNED(A)>SIGNED(B)		)	AND	sel='1'	)	ELSE
			'1' WHEN	(	(	UNSIGNED(A)>UNSIGNED(B)	)	AND	sel='0'	)	ELSE
			'0';
	ls	<=	'1' WHEN	(	(	SIGNED(A)<SIGNED(B)		)	AND	sel='1'	)	ELSE
			'1' WHEN	(	(	UNSIGNED(A)<UNSIGNED(B)	)	AND	sel='0'	)	ELSE
			'0';
	--============================================
	
END ARCHITECTURE functional;


