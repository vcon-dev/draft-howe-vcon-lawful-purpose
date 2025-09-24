# draft-howe-vcon-lawful-purpose 
# 
versioned:
	@mkdir -p $@
.INTERMEDIATE: versioned/draft-howe-vcon-lawful-purpose-00.md
versioned/draft-howe-vcon-lawful-purpose-00.md: draft-howe-vcon-lawful-purpose.md | versioned
	sed -e 's/draft-howe-vcon-lawful-purpose-date/2025-09-24/g' -e 's/draft-howe-vcon-lawful-purpose-latest/draft-howe-vcon-lawful-purpose-00/g' -e '/^{::include [^\/]/{ s/^{::include /{::include draft-howe-vcon-lawful-purpose-00\//; }' $< >$@
	for inc in $$(sed -ne '/^{::include [^\/]/{ s/^{::include draft-howe-vcon-lawful-purpose-00\///;s/}$$//; p; }' $@); do \
	  target=draft-howe-vcon-lawful-purpose-00/$$inc; \
	  mkdir -p $$(dirname "$$target"); \
	  git show "$$tag:$$inc" >"$$target" || \
	    (echo "Attempting to make a copy of $$inc"; \
	     tmp=.; \
	     make -C "$$tmp" "$$inc" && cp "$$tmp/$$inc" "$$target"; \
	  ); \
	done
