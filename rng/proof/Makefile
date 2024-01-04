.PHONY: all
all: rng.rkt

.PHONY: clean
clean:
	rm -rf rng.smt2 rng.rkt

rng.smt2: ../impl/rng.v
	yosys \
		-p 'read_verilog -defer $^' \
		-p 'prep -flatten -top rng -nordff' \
		-p 'write_smt2 -stdt rng.smt2'

%.rkt: %.smt2
	echo '#lang yosys' > $@
	cat $< >> $@