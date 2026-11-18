MACHINE := longhorn
# Define the target platforms that can be used across the ecosystem.
DEFAULT_PLATFORMS := linux/amd64,linux/arm64

.PHONY: validate test ci
validate:
	docker buildx build --target validate -f Dockerfile .

test: validate

ci:
	docker buildx build --target ci-artifacts --output type=local,dest=. -f Dockerfile .

.PHONY: buildx-machine
buildx-machine:
	@docker buildx create --name=$(MACHINE) --platform=$(DEFAULT_PLATFORMS) 2>/dev/null || true
	docker buildx inspect $(MACHINE)

.DEFAULT_GOAL := ci
