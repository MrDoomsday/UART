onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_mm_top_tb/DUT/clk
add wave -noupdate /uart_mm_top_tb/DUT/reset_n
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_awaddr
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_awprot
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_awvalid
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_awready
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_wdata
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_wstrb
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_wvalid
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_wready
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_bresp
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_bvalid
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_bready
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_araddr
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_arprot
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_arvalid
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_arready
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_rdata
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_rresp
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_rvalid
add wave -noupdate -expand -group AXI-Lite /uart_mm_top_tb/DUT/s_axil_rready
add wave -noupdate -expand -group UART /uart_mm_top_tb/DUT/uart_rx
add wave -noupdate -expand -group UART /uart_mm_top_tb/DUT/uart_tx
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_wr
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_rd
add wave -noupdate -group internal_bus -radix unsigned /uart_mm_top_tb/DUT/fifo_tx_fill
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_din
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_dout
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_full
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_tx_empty
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_wr
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_rd
add wave -noupdate -group internal_bus -radix unsigned /uart_mm_top_tb/DUT/fifo_rx_fill
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_din
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_dout
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_full
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/fifo_rx_empty
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_pbit
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_sbit
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_ptype
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_baud_limit
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_baud_update
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_tx_en
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/cr_rx_en
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/tx_data_i
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/tx_valid_i
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/tx_ready_o
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_data_o
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_pbit_error
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_valid_o
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_read
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_readdata
add wave -noupdate -group internal_bus /uart_mm_top_tb/DUT/rx_readdatavalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51762935 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 288
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
WaveRestoreZoom {51359840 ns} {52449398 ns}
