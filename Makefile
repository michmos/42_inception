PROJECT_DIR	:=	srcs

run: .setup_done
	docker compose --project-directory $(PROJECT_DIR) up --detach

setup:
	mkdir -p /home/$(USER)/data/wordpress/ /home/$(USER)/data/mysql/
	@bash setup.sh
	$(MAKE) build
	@touch .setup_done

.setup_done:
	$(MAKE) setup

build:
	docker compose --project-directory $(PROJECT_DIR) build

logs:
	docker compose --project-directory $(PROJECT_DIR) logs -f

stop:
	docker compose --project-directory $(PROJECT_DIR) stop

clean:
	rm -f .setup_done
	docker compose --project-directory $(PROJECT_DIR) down --volumes --rmi all
	rm -rf secrets srcs/.env

re:
	$(MAKE) clean
	$(MAKE) setup

.PHONY: build setup run stop clean re
