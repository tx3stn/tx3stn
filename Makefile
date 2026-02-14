PLAYWRIGHT_IMAGE ?= mcr.microsoft.com/playwright:v1.41.2-jammy
PLAYWRIGHT_NPM_VERSION ?= 1.41.2

.PHONY: capture-cards
capture-cards:
	docker run --rm -v "$(PWD):/work" \
		-w /work $(PLAYWRIGHT_IMAGE) \
		bash -lc 'set -euo pipefail; mkdir -p /tmp/capture; cp /work/img/capture-cards.mjs /tmp/capture/capture-cards.mjs; cd /tmp/capture; npm init -y >/dev/null 2>&1; npm install --no-audit --no-fund playwright@$(PLAYWRIGHT_NPM_VERSION) >/dev/null; node /tmp/capture/capture-cards.mjs'

.PHONY: fix-images
fix-images:
	./fix-card-transparency.sh
