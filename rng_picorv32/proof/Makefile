.PHONY: all
all: rng.rkt

SOC_V := $(shell find ../impl/hw/soc -name '*.v')

MEM := ../impl/fw/rng.mem

.PHONY: FORCE

$(MEM): FORCE
	$(MAKE) -C ../impl/ fw/rng.mem

rng.smt2: ../impl/hw/rng.v $(SOC_V) $(MEM)
	cd ../impl; \
	yosys \
		-p "read_verilog -defer $< $$(find hw/soc -name '*.v' | tr '\n' ' ')" \
		-p 'prep -flatten -top rng -nordff' \
		-p 'write_smt2 -stdt ../proof/rng.smt2'

rng.rkt: rng.smt2
	echo '#lang yosys' > $@
	cat $< >> $@

.PHONY: clean
clean:
	rm -f rng.rkt rng.smt2
