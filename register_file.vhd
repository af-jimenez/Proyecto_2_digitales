LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
---------------------------------------------------
ENTITY register_file IS

	GENERIC(	DATA_WIDTH	:	INTEGER	:=	4;
				ADDR_WIDTH	:	INTEGER	:=	3);
	PORT(		clk		:	IN		STD_LOGIC;
				rst		:	IN		STD_LOGIC;
				wr_en		:	IN		STD_LOGIC;
				w_addr_i	:	IN		STD_LOGIC_VECTOR(	ADDR_WIDTH-1 DOWNTO 0 );
				w_addr_j	:	IN		STD_LOGIC_VECTOR(	DATA_WIDTH-1 DOWNTO 0 );
				r_addr_i	:	IN		STD_LOGIC_VECTOR(	ADDR_WIDTH-1 DOWNTO 0 );
				r_addr_j	:	IN		STD_LOGIC_VECTOR(	DATA_WIDTH-1 DOWNTO 0 );
				w_data	:	IN		STD_LOGIC;
				r_data	:	OUT	STD_LOGIC
				);
	
END ENTITY;
---------------------------------------------------
ARCHITECTURE rtl OF register_file IS

	TYPE	mem_type	IS	ARRAY	(0	TO	2**ADDR_WIDTH-1)	OF	STD_LOGIC_VECTOR( 2**DATA_WIDTH-1 DOWNTO 0 );
	SIGNAL	array_reg	:	mem_type;
	SIGNAL	zeros	:	mem_type	:=	(OTHERS	=> "0000000000000000");
	
BEGIN
	
	zeros	<=	(OTHERS => "0000000000000000");
	
	--WRITE PROCESS
	write_process: PROCESS(clk, rst)
	BEGIN
		IF	(rising_edge(clk)) THEN
			IF	(rst = '0')	THEN
				IF	(wr_en = '1')	THEN
					array_reg(to_integer(unsigned(w_addr_i)))(to_integer(unsigned(w_addr_j)))	<=	w_data;
				END IF;
			ELSE
				array_reg	<=	zeros;
			END IF;
		END IF;
	END PROCESS;
	
	--READ
	r_data	<=	array_reg(to_integer(unsigned(r_addr_i)))(to_integer(unsigned(r_addr_j)));

END ARCHITECTURE;