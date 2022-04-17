library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity mem_file is
  generic(
		data_length: integer := 16;
		num_reg: integer := 65536);
		
  port(clk: in std_logic;
      wr_ena: in std_logic;
      add: in std_logic_vector(15 downto 0);
      data_in: in std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0));
end entity;

architecture mem of mem_file is
  type RAM_array is array (0 to num_reg-1) of std_logic_vector (15 downto 0);
	signal RAM : RAM_array:= (X"3115",X"32C7",X"0050",X"039A",others=>X"0000");
begin
  process(clk, wr_ena, data_in, add, RAM)
    begin
    if rising_edge(clk) then
      if(wr_ena = '0') then
        RAM(to_integer(unsigned(add)))<= data_in;
      end if;
    end if;
      data_out <= RAM(to_integer(unsigned(add)));
  end process;
end architecture mem;