# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: alejandj <alejandj@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/09/30 18:17:08 by alejandj          #+#    #+#              #
#    Updated: 2026/09/30 20:33:03 by alejandj         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DIR_COMPOSE = srcs/docker-compose.yml
IMAGES =	mariadb \

GREEN = \033[1;32m
BLUE = \033[1;34m
RED = \033[1;31m
YELLOW = \033[1;33m
RESET = \033[0m

all: up

up:
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(GREEN)🚀 Iniciando Servicios...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	docker compose -f $(DIR_COMPOSE) up -d --build
	@echo "$(YELLOW)✨ ¡Contenedores desplegados con éxito!$(RESET)"

down:
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(GREEN) Apagando Servicios...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	docker compose -f $(DIR_COMPOSE) down

enter:
	docker exec -it mariadb bash

clean: down
	@echo "$(BLUE)====================================================$(RESET)"
	@echo "$(RED)🧹 Limpiando imagenes...$(RESET)"
	@echo "$(BLUE)====================================================$(RESET)"
	@for img in $(IMAGES); do \
			docker rmi -f $$img; \
	done
	@echo "$(YELLOW)🗑️ Limpieza de imagenes completada.$(RESET)"
	
re: clean up

.PHONY: all up down enter clean re
