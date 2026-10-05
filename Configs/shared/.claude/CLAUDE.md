# R code formatting

Always format R code with the Air formatter (`air` is on PATH). A PostToolUse hook runs `air format` on `.R` files after every Write/Edit, so write R code in Air's style to begin with. Files created or changed through Bash aren't covered by the hook, so run `air format <path>` on those yourself.
