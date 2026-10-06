# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alejandj <alejandj@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/09/30 18:17:08 by alejandj          #+#    #+#              #
#    Updated: 2026/10/03 19:32:11 by alejandj         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DIR_COMPOSE = srcs/docker-compose.yml
DIR_DATA = /home/alejandj/data

IMAGES =	mariadb \

GREEN = \033[1;32m
BLUE = \033[1;34m
RED = \033[1;31m
YELLOW = \033[1;33m
RESET = \033[0m

all: up

init_dirs:
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(GREEN)[INFO] Creating data directories...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@mkdir -p $(DIR_DATA)/mariadb
	@echo "$(YELLOW)[OK] Directories ready!$(RESET)"

up: init_dirs
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(GREEN)[INFO] Starting Services...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@docker compose -f $(DIR_COMPOSE) up -d --build
	@echo "$(YELLOW)[OK] All services started successfully!$(RESET)"

down:
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(RED)[INFO] Shutting Down Services...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@docker compose -f $(DIR_COMPOSE) down
	@echo "$(YELLOW)[OK] Services stopped successfully!$(RESET)"

enter:
	@docker exec -it mariadb bash

clean: down
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(RED)[INFO] Cleaning images...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@for img in $(IMAGES); do \
		docker rmi -f $$img 2>/dev/null || true; \
	done
	@echo "$(YELLOW)[OK] Image cleanup complete.$(RESET)"
	
fclean: clean
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(RED)[INFO] Cleaning volumes...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@docker volume rm -f mariadb_data 2>/dev/null || true
	@echo "$(YELLOW)[OK] Volumes cleanup complete.$(RESET)"
	
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(RED)[INFO] Cleaning directories...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@sudo rm -rf $(DIR_DATA)
	@echo "$(YELLOW)[OK] Directories cleanup complete.$(RESET)"    
	
re: fclean up

.PHONY: all up down enter clean fclean re
