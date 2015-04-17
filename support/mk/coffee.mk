COFFEE_SRC = src
COFFEE_SRC_LIST = $(shell find $(COFFEE_SRC) -name "*.coffee")
COFFEE_BUILD = lib
COFFEE_BIN = node_modules/.bin/coffee

# Coffee -> JS
$(COFFEE_BUILD): $(COFFEE_SRC_LIST) node_modules
	@echo Using `$(COFFEE_BIN) -v`
	@mkdir -p $(COFFEE_BUILD)
	@$(COFFEE_BIN) --output $(COFFEE_BUILD) --compile $(COFFEE_SRC)
	@touch $(COFFEE_BUILD)
	@echo Done!

# Clean all compiled files
coffee-clean: node_modules
	@echo Cleaning compiled coffee code
	@rm -rf $(COFFEE_BUILD)

# Build all JS files
coffee-compile: $(COFFEE_BUILD)

# Rebuild JS when Coffee source changes
coffee-watch: coffee-compile
	@echo Watching for coffee source changes
	@$(COFFEE_BIN) --output $(COFFEE_BUILD) --compile $(COFFEE_SRC) --watch

# Verify that the checked-in JS matches the latest Coffee code
coffee-verify: node_modules
	@$(COFFEE_BIN) --output $(COFFEE_BUILD)-latest --compile $(COFFEE_SRC)
	@diff $(COFFEE_BUILD) $(COFFEE_BUILD)-latest

.PHONY: coffee-clean coffee-compile coffee-watch coffee-verify
