LIBRARY IEEE;
USE ieee.std_logic_1164.all;
---------------------------------------------------------
ENTITY decoder3_8 IS
	PORT(		x		:	IN		STD_LOGIC_VECTOR(2 DOWNTO 0);
				en		:	IN		STD_LOGIC;
				y		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY decoder3_8;
---------------------------------------------------------
ARCHITECTURE functional OF decoder3_8 IS
	SIGNAL enx	:	std_LOGIC_VECTOR(3 downto 0);
	
BEGIN
	
	enx <= en & x;
	
		WITH enx SELECT
			y	<=	"00000001" WHEN "1000",
					"00000010" WHEN "1001",
					"00000100" WHEN "1010",
					"00001000" WHEN "1011",
					"00010000" WHEN "1100",
					"00100000" WHEN "1101",
					"01000000" WHEN "1110",
					"10000000" WHEN "1111",
					"00000000" WHEN OTHERS;

END ARCHITECTURE functional;