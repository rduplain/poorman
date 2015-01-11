DIR := $(dir $(lastword $(MAKEFILE_LIST)))
PROJECT_ROOT := $(abspath $(dir $(abspath $(DIR))))

export PROJECT_ROOT
