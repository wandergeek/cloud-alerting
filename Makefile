SHELL = /bin/bash
MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))

NO_COLOR = \033[0m
OK_COLOR = \033[0;32m
ERROR_COLOR = \033[1;31m
WARN_COLOR = \033[0;33m

OK_STRING = $(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING = $(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING = $(WARN_COLOR)[WARNING]$(NO_COLOR)
INFO_STRING = $(WARN_COLOR)[INFO]$(NO_COLOR)

.DEFAULT_GOAL =  help

VERSION := $(shell cat package.json | jq -r .version)

.PHONY: help
help:
	@printf "$(WARN_COLOR)\n"
	@printf "                                                                                                                      \n"
	@printf "     _/_/_/  _/                            _/        _/_/    _/                        _/      _/                      \n"
	@printf "  _/        _/    _/_/    _/    _/    _/_/_/      _/    _/  _/    _/_/    _/  _/_/  _/_/_/_/      _/_/_/      _/_/_/   \n"
	@printf " _/        _/  _/    _/  _/    _/  _/    _/      _/_/_/_/  _/  _/_/_/_/  _/_/        _/      _/  _/    _/  _/    _/    \n"
	@printf "_/        _/  _/    _/  _/    _/  _/    _/      _/    _/  _/  _/        _/          _/      _/  _/    _/  _/    _/     \n"
	@printf " _/_/_/  _/    _/_/      _/_/_/    _/_/_/      _/    _/  _/    _/_/_/  _/            _/_/  _/  _/    _/    _/_/_/      \n"
	@printf "                                                                                                              _/       \n"
	@printf "                                                                                                         _/_/          \n"
	@printf "$(NO_COLOR)\n"
	@echo "Kibana plugins for Alerting as a Service." 
	@echo ""
	@echo "build - build the cloud-alerting container"
	@echo "push - push the cloud-alerting container"


.PHONY: build
build:
	@docker build -t found/cloud-alerting:$(VERSION) .

.PHONY: push
push:
	@docker push found/cloud-alerting:$(VERSION) 