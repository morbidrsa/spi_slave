YOSYS = yosys
NEXTPNR = nextpnr-ice40
ICEPACK = icepack
ICETIME = icetime

DEVICE = up5k
PCF = ice40_stick.pcf
ASC = spi_slave.asc
BIN = spi_slave.bin
JSON = spi_slave.json

SRC = spi_slave.v

all: $(BIN)

synth: $(SRC)
	$(YOSYS) -p "read_verilog $(SRC); synth_ice40 -top spi_slave -json $(JSON)"

place_route: synth
	$(NEXTPNR) --$(DEVICE) --json $(JSON) --pcf $(PCF) --asc $(ASC) --package sg48

bitstream: place_route
	$(ICEPACK) $(ASC) $(BIN)

timing: bitstream
	$(ICETIME) -d $(DEVICE) -t $(ASC)

$(BIN): synth place_route bitstream timing

clean:
	rm -f $(JSON) $(ASC) $(BIN)

