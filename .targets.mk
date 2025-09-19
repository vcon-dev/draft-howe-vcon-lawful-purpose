# draft-howe-vcon-consent 
# 
versioned:
	@mkdir -p $@
.INTERMEDIATE: versioned/draft-howe-vcon-consent-00.md
versioned/draft-howe-vcon-consent-00.md: draft-howe-vcon-consent.md | versioned
	sed -e 's/draft-howe-vcon-consent-date/2025-07-21/g' -e 's/draft-howe-vcon-consent-latest/draft-howe-vcon-consent-00/g' $< >$@
