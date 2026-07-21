#!/usr/bin/env bash
set -euo pipefail
helm template discourse charts/discourse "$@"
