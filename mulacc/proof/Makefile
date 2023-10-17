.PHONY: all
all: mulacc.rkt

.PHONY: clean
clean:
	rm -rf mulacc.smt2 mulacc.rkt

mulacc.smt2: ../impl/mulacc.v
	yosys \
		-p 'read_verilog -defer $^' \
		-p 'prep -flatten -top mulacc -nordff' \
		-p 'write_smt2 -stdt mulacc.smt2'

%.rkt: %.smt2
	echo '#lang yosys' > $@
	cat $< >> $@