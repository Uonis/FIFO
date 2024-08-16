vlib work
vlog fifo.v tb_fifo.v
vsim -voptargs=+acc work.tb_fifo
add wave *
add wave /tb_fifo/dut/mem
run -all
#quit -sim