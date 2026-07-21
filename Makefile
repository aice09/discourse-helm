CHART := charts/discourse
RELEASE := discourse

.PHONY: lint template test

lint:
	helm lint $(CHART)

template:
	helm template $(RELEASE) $(CHART)

test: lint template
