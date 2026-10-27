filename = top
pcf_file = ./iceBlinkPico.pcf
srcs = top.sv controller.sv ws2812b.sv memory.sv cell.sv game.sv

build:
	yosys -p "synth_ice40 -top top -json $(filename).json" $(srcs)
	nextpnr-ice40 --up5k --package sg48 --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
	icepack $(filename).asc $(filename).bin

prog: #for sram
	dfu-util --device 1d50:6146 --alt 0 -D $(filename).bin -R

sim:
	iverilog -g2012 -o game_tb.vvp game_tb.sv game.sv
	vvp game_tb.vvp

clean:
	rm -rf $(filename).blif $(filename).asc $(filename).json $(filename).bin *.vvp *.vcd a.out
