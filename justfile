#!/usr/bin/env just --justfile

top := env_var_or_default('TOP', invocation_directory())
formatter := env_var_or_default('FORMATTER', 'nixpkgs-fmt')
linter := env_var_or_default('LINTER', '')

default: build

build: lint && _reload
    darwin-rebuild build --flake .

install: build
    darwin-rebuild switch --flake .

format: _reload
    {{ formatter }} {{ top }}

lint: format

clean: && _reload
	git clean -f

gc: && _reload
	git gc
	nix store gc --quiet &

purge: clean && gc _reload
	git repack -a -d
	git reflog expire --all --expire=now

_reload:
	nix-direnv-reload
