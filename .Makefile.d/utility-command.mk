%-command:
	@which $* >/dev/null || ( echo "Requires '$*' command."; false )

.PHONY: %-command
