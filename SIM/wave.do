onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tb/DUT/clk
add wave -noupdate /uart_tb/DUT/reset_n
add wave -noupdate -expand -group tx /uart_tb/DUT/tx_data_i
add wave -noupdate -expand -group tx /uart_tb/DUT/tx_valid_i
add wave -noupdate -expand -group tx /uart_tb/DUT/tx_ready_o
add wave -noupdate -expand -group rx /uart_tb/DUT/rx_data_o
add wave -noupdate -expand -group rx /uart_tb/DUT/rx_valid_o
add wave -noupdate -expand -group rx /uart_tb/DUT/rx_pbit_error
add wave -noupdate /uart_tb/DUT/uart_rx
add wave -noupdate /uart_tb/DUT/uart_tx
add wave -noupdate -expand -group {control register} /uart_tb/cr_pbit
add wave -noupdate -expand -group {control register} /uart_tb/cr_ptype
add wave -noupdate -expand -group {control register} /uart_tb/cr_sbit
add wave -noupdate -expand -group {control register} /uart_tb/cr_baud_freq
add wave -noupdate -expand -group {control register} /uart_tb/cr_baud_limit
add wave -noupdate /uart_tb/DUT/ce_16
add wave -noupdate /uart_tb/DUT/tx_busy
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/clock
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/reset
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/pbit
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/ptype
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/sbit
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/ce_16
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/tx_data
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/new_tx_data
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/ser_out
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/tx_busy
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/ce_1
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/count16
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/bit_count
add wave -noupdate -expand -group tx_module -expand /uart_tb/DUT/uart_tx_inst/data_buf
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/pbit_r
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/ptype_r
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/parity_bit
add wave -noupdate -expand -group tx_module /uart_tb/DUT/uart_tx_inst/sbit_r
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/clock
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/reset
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/pbit
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ptype
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/sbit
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ce_16
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ser_in
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/rx_data
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/new_rx_data
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/pbit_error
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ce_1
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ce_1_mid
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/in_sync
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/rx_busy
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/count16
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/bit_count
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/data_buf
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/pbit_r
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/ptype_r
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/sbit_r
add wave -noupdate -expand -group rx_module /uart_tb/DUT/uart_rx_inst/parity_check
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {102222450 ns} 1} {{Cursor 3} {102217316 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {102214963 ns} {102230707 ns}
