deploy:
	$(call upload_data,reach-ui,reach-dev.skunkworksngwsa.de)

.PHONY: deploy

define upload_data
	aws s3 rm s3://$(1) --recursive
	aws s3 sync dist s3://$(1) --acl public-read
endef
