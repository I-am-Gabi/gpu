all:
	ghdl -i circ_abs.vhd circ_line.vhd pc_circ_line.vhd top_line.vhd top_line_tb.vhd 
	ghdl -m top_line_tb
	./top_line_tb --stop-time=800ns --wave=ondas.ghw
