DBT = uv run dbt --no-use-colors
FLAGS = --profiles-dir .

.PHONY: setup build bug demo docs serve clean

setup:
	uv sync

build:
	$(DBT) build $(FLAGS)

# Corrupts order line quantities. The build is expected to fail on assert_order_lines_sum_to_total.
bug:
	$(DBT) build $(FLAGS) --vars '{inject_bug: true}' || echo "\n==> The tests caught the injected bug, as they should."

demo:
	./scripts/demo.sh

docs:
	$(DBT) docs generate $(FLAGS)

serve: docs
	$(DBT) docs serve $(FLAGS)

clean:
	rm -rf target logs
