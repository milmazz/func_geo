ELIXIR = elixir

.PHONY: compile

COMPILE_EXAMPLES = cd examples/$(1) && ELIXIR "$(1).exs"

compile:
	@ echo "==> Generating examples for 'f'"
	$(call COMPILE_EXAMPLES,f)
	@ echo "==> Generating examples for 'man'"
	$(call COMPILE_EXAMPLES,man)
	@ echo "==> Generating examples for 'fishes'"
	$(call COMPILE_EXAMPLES,fishes)
	@ echo "==> Done."

default: compile

clean:
	rm -f examples/*/*.ps
	rm -f examples/*/*.svg

