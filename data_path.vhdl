library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.components.all;
use work.signextender.all;

entity data_path is
	port(
	op_code: out std_logic_vector(3 downto 0);
	CZ: out std_logic_vector(1 downto 0);
	clock, wren,rden: in std_logic;
	C: in std_logic_vector(29 downto 0);
	state: out std_logic_vector(4 downto 0));
end entity;

architecture struct of data_path is

	component ls_multiple is
		generic(input_width: integer := 8);
		port(
			input: in std_logic_vector(input_width-1 downto 0);
			ena, clk, set_zero: in std_logic;
			valid, invalid_next: out std_logic;
			address: out std_logic_vector(integer(ceil(log2(real(input_width))))-1 downto 0));
	end component;
	
	component alu is
		generic(alu_length: integer := 16);
		port(
			input1, input2: in std_logic_vector(alu_length-1 downto 0);
		output: out std_logic_vector(alu_length-1 downto 0);
		sel:in std_logic_vector(1 downto 0);
		cin: in std_logic;
		CY, Z: out std_logic);
	end component;
	
	component reg_file is
	generic(
		data_length: integer := 16;
		num_reg: integer := 8);
		
	port(
		data_in: in std_logic_vector(data_length-1 downto 0);
		rf_df1, rf_df2, R7_PC: out std_logic_vector(data_length-1 downto 0);
		sel_in, sel_out1, sel_out2: in std_logic_vector(integer(ceil(log2(real(num_reg))))-1 downto 0);
		clk, wr_ena: in std_logic);
		
end component;
	
	component mem_file is
	generic(
		data_length: integer := 16;
		num_reg: integer := 8);
		
	port(
		data_in: in std_logic_vector(data_length-1 downto 0);
		data_out: out std_logic_vector(data_length-1 downto 0);
		add: in std_logic_vector(integer(ceil(log2(real(num_reg))))-1 downto 0);
		clk, wr_ena: in std_logic);
		
end component;

signal IR, rf_df1, rf_df2, rf_df3, SE7, SE10, S1, ALU_A, ALU_B, ALU_C, T1, T2,T3,mem_d,R7_PC,T1_IN,T2_IN,T3_IN,mem_in: std_logic_vector(15 downto 0) := (others => '0');--mem_d1=doim mem_d1=do-dm
signal PC_IN,PC: std_logic_vector(15 downto 0) := (others => '0');
signal alu_op: std_logic_vector(1 downto 0) := (others => '0');
signal rfa1, rfa2, rfa3, PE: std_logic_vector(2 downto 0) := (others => '0');
signal CY, Z: std_logic_vector(0 downto 0) := (others => '0');
signal temp,nor_out: std_logic;


begin 
Instruction_reg:reg_process
generic map(16)
port map(clk => clock, ena => C(21), 
				Din => mem_d, Dout => IR);
				
regfile: reg_file
generic map(16,8)
		port map(clk => clock, wr_ena => C(0), data_in => rf_df3, R7_PC => R7_PC, 
		rf_df1 => rf_df1, rf_df2 => rf_df2, sel_in => rfa3, sel_out1 => rfa1, sel_out2 => rfa2);
		
nor1:nor_8
generic map(8)
port map (A=>IR(7 downto 0),S =>nor_out);		
pe_block: ls_multiple
		port map( input => IR(7 downto 0), ena => C(22), clk => clock, set_zero => nor_out, invalid_next => state(0), address => PE);

sign_extend10:sign_extend_6 
generic map(6,16)
port map (input=>IR(5 downto 0),output =>SE10);

sign_extend7:sign_extend_9 
generic map(9,16)
port map (input=>IR(8 downto 0),output =>SE7);

alu_instance: alu
generic map(16)
port map (input1=>ALU_A,input2=>ALU_B,output =>ALU_C,cin=>'0',sel=>alu_op,CY=>CY(0),Z=>Z(0));

mem:mem_file
generic map(16,65536)
		port map(clk => clock, wr_ena => wren,data_in => T2, data_out=>mem_d,add=>mem_in );
		
T1_reg:reg_process
generic map(16)
port map(clk => clock, ena => C(26), 
				Din => T1_IN, Dout => T1);
				
T2_reg:reg_process
generic map(16)
port map(clk => clock, ena => C(27), 
				Din => T2_IN, Dout => T2);
	
T3_reg:reg_process
generic map(16)
port map(clk => clock, ena => C(28), 
				Din => T3_IN, Dout => T3);
				
PC_reg:reg_process
generic map(16)
port map(clk => clock, ena => C(29), 
				Din => PC_IN, Dout => PC);
				
S1 <= IR(8 downto 0) & "0000000" when (IR(15) = '0') else
		"0000000" & IR(8 downto 0);
		
rfa1 <=IR(8 downto 6) when C(1)= '0' and C(2) = '0' else
		 IR(11 downto 9)when C(1)= '0' and C(2) = '1' else
		 PE when C(1)= '1' and C(2) = '0';
rfa2 <= IR(5 downto 3) when C(3)= '0' and C(4) = '0' else
			IR(8 downto 6) when C(3)= '0' and C(4) = '1' else
			IR(11 downto 9) when C(3)= '1' and C(4) = '0' ;
rfa3<=IR(11 downto 9) when C(5)= '0' and C(6) = '0' else
		"111" when C(5)= '0' and C(6) = '1' else
		PE when C(5)= '1' and C(6) = '0';
		
mux81:mux8
generic map(16)
port map(sel=>C(16 downto 14),inp1=>SE10,inp2=>T2,inp5=>PC,inp3=>SE7,inp7=>"0000000000000001",output=>ALU_B);

mux41:mux4_16
generic map(16)
port map(sel=>C(13 downto 12),inp1=>T1,inp2=>SE7,inp3=>PC,inp4=>rf_df1,output=>ALU_A);

mux21:mux2
generic map(16)
port map(sel=>C(11),inp1=>rf_df1,inp2=>ALU_C,output=>T1_IN);

mux42:mux4_16
generic map(16)
port map(sel=>C(10 downto 9),inp1=>rf_df1,inp2=>rf_df2,inp3=>mem_d,output=>T2_IN);

mux22:mux2
generic map(16)
port map(sel=>C(19),inp1=>ALU_C,inp2=>mem_d,output=>T3_IN);

pc_mux:mux2
generic map(16)
port map(sel=>C(20),inp1=>rf_df1,inp2=>ALU_C,output=>PC_IN);

mux43:mux4_16
generic map(16)
port map(sel=>C(18 downto 17),inp1=>T1,inp2=>T3,inp3=>PC,output=>mem_in);

mux44:mux4_16
generic map(16)
port map(sel=>C(8 downto 7),inp1=>T3,inp2=>PC,inp3=>T2,inp4=>IR(8 downto 0) & "0000000",output=>rf_df3);

CZ <=IR(1 downto 0);

alu_op <= "00" when (IR(15 downto 12) = "0001" or IR(15 downto 12) = "0000") else 
				"01" when (IR(15 downto 12) = "1000") else
				"10" when (IR(15 downto 12) = "0010") ;
				
end architecture;