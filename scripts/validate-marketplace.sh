#!/usr/bin/env bash
# Validate .claude-plugin/marketplace.json against the Claude Code marketplace schema.
set -euo pipefail
file="${1:-.claude-plugin/marketplace.json}"
jq -e '
  (.name | type == "string" and length > 0)
  and (.owner | type == "object" and (.name | type == "string" and length > 0))
  and (.plugins | type == "array")
  and all(.plugins[];
    (.name | type == "string" and length > 0)
    and (.source | (type == "string" and length > 0)
      or (type == "object" and (.source | type == "string")
          and ((.repo // .url) | type == "string"))))
' "$file" >/dev/null || { echo "invalid marketplace schema: $file" >&2; exit 1; }
echo "ok: $file"
