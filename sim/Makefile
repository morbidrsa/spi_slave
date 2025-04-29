IVERILOG = iverilog
VVP = vvp

all: run

spi_slave_tb: spi_slave_tb.v ../rtl/spi_slave.v
	$(IVERILOG) -o spi_slave_tb ../rtl/spi_slave.v spi_slave_tb.v

run: spi_slave_tb
	$(VVP) spi_slave_tb

clean:
	rm -f spi_slave_tb *.vcd
