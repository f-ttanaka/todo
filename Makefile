SOFTWARES = stack

check_libpq:
	@if ! command -v pkg-config > /dev/null 2>&1; then \
		echo "Error: libpq (PostgreSQL client library) is not installed."; \
		exit 1; \
	fi

check_requirement_for_echo:
	@for cmd in $(SOFTWARES); do \
		if ! command -v $$cmd > /dev/null 2>&1; then \
			echo "Error: $$cmd is not installed."; \
			exit 1; \
		fi; \
	done

.PHONY: check-requirement
check-requirement:
	@make check_libpq check_requirement_for_echo