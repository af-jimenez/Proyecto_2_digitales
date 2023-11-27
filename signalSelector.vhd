LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.my_pkg.ALL;
----------------------------------------
ENTITY signalSelector IS
	PORT	(	clk			:	IN		STD_LOGIC;
				rst			:	IN		STD_LOGIC;
				game_sig		:	IN		STD_LOGIC;
				wr_en_s1		:	IN		STD_LOGIC;
				w_addr_s1_i	:	IN		STD_LOGIC_VECTOR(	2 DOWNTO 0 );
				w_addr_s1_j	:	IN		STD_LOGIC_VECTOR(	3 DOWNTO 0 );
				w_data_s1	:	IN		STD_LOGIC;
				wr_en_s2		:	IN		STD_LOGIC;
				w_addr_s2_i	:	IN		STD_LOGIC_VECTOR(	2 DOWNTO 0 );
				w_addr_s2_j	:	IN		STD_LOGIC_VECTOR(	3 DOWNTO 0 );
				w_data_s2	:	IN		STD_LOGIC;
				wr_en			:	OUT	STD_LOGIC;
				w_addr_j		:	OUT	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
				w_addr_i		:	OUT	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
				w_data		:	OUT	STD_LOGIC);
END ENTITY;
----------------------------------------
ARCHITECTURE arch OF signalSelector IS

	TYPE state IS (st0, st1, st2, st3);
	SIGNAL pr_state, nx_state	:	state;
	
	SIGNAL	w_addr_sc_j	:	STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL	w_addr_sc_i	:	STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL	w_data_sc	:	STD_LOGIC;
	SIGNAL	wr_en_sc		:	STD_LOGIC;
	
	SIGNAL anim_img	:	img_mtx;
	
BEGIN
	
	anim_img		<= (	conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"),
							conv_slv("0000000000000000"));
	
	frame3_print: ENTITY work.imageManagement
				PORT MAP (clk      =>	clk,
							rst      =>	rst,
							ena      =>	'1',
							imageIn	=>	anim_img,
							wr_en		=>	wr_en_sc,
							w_addr_j	=>	w_addr_sc_j,
							w_addr_i	=>	w_addr_sc_i,
							w_data	=>	w_data_sc);
	
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
	combinational: PROCESS(pr_state, game_sig)
	BEGIN
		CASE pr_state IS
			WHEN st0	=>
				wr_en		<=	wr_en_s1;
				w_addr_j	<=	w_addr_s1_j;
				w_addr_i	<=	w_addr_s1_i;
				w_data	<=	w_data_s1;
				IF (game_sig = '0') THEN
					nx_state	<= st1;
				ELSE
					nx_state	<= st0;
				END IF;
			WHEN st1	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st2;
			WHEN st2	=>
				wr_en		<=	wr_en_s2;
				w_addr_j	<=	w_addr_s2_j;
				w_addr_i	<=	w_addr_s2_i;
				w_data	<=	w_data_s2;
				IF (game_sig = '1') THEN
					nx_state	<= st3;
				ELSE
					nx_state	<= st2;
				END IF;
			WHEN st3	=>
				wr_en		<=	wr_en_sc;
				w_addr_j	<=	w_addr_sc_j;
				w_addr_i	<=	w_addr_sc_i;
				w_data	<=	w_data_sc;
				nx_state	<=	st0;
		END CASE;
	END PROCESS combinational;
END ARCHITECTURE;