all: sim

sim:
	$(MAKE) -C sim/ 

clean:
	$(MAKE) -C sim/ clean


.PHONY: all sim clean
