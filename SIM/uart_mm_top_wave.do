onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_mm_top_tb/clk
add wave -noupdate /uart_mm_top_tb/reset_n
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_write_i
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_address_i
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_writedata_i
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_read_i
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_waitrequest_o
add wave -noupdate -expand -group Avalon-Slave /uart_mm_top_tb/avmms_readdata_o
add wave -noupdate /uart_mm_top_tb/uart_tx_rx
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/clk
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/reset_n
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_write_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_address_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_writedata_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_read_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_waitrequest_o
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/avmms_readdata_o
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/uart_rx
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/uart_tx
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_wr
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_rd
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_fill
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_din
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_dout
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_full
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_tx_empty
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_wr
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_rd
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_fill
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_din
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_dout
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_full
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/fifo_rx_empty
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/cr_pbit
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/cr_sbit
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/cr_ptype
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/cr_baud_limit
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/tx_data_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/tx_valid_i
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/tx_ready_o
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_data_o
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_pbit_error
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_valid_o
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_read
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_readdata
add wave -noupdate -expand -group uart_mm_top /uart_mm_top_tb/DUT/rx_readdatavalid
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/clk
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/reset_n
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/wr
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/data_in
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/rd
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/data_out
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/full
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/empty
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/use_words
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/clear
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/wr_ptr
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/rd_ptr
add wave -noupdate -group fifo_tx /uart_mm_top_tb/DUT/fifo_tx/cnt_word
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/clk
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/reset_n
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_write_i
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_address_i
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_writedata_i
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_read_i
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_waitrequest_o
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/avmms_readdata_o
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/cr_pbit
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/cr_sbit
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/cr_ptype
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/cr_baud_limit
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_tx_empty
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_tx_full
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_tx_fill
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_rx_empty
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_rx_full
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/fifo_rx_fill
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/tx_byte
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/tx_valid
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/rx_read
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/rx_readdata
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/rx_readdatavalid
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/next_waitrequest
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/write_transaction
add wave -noupdate -expand -group avalon_to_reg /uart_mm_top_tb/DUT/avalon_to_reg_inst/read_transaction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {72583545 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {72232230 ns} {73058893 ns}
