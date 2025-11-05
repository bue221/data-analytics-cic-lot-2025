.PHONY: help install setup clean test check-env venv run-notebook install-dev

# Variables
PYTHON := python3
VENV := venv
VENV_BIN := $(VENV)/bin
PIP := $(VENV_BIN)/pip
PYTHON_VENV := $(VENV_BIN)/python
REQUIREMENTS := requirements.txt
NOTEBOOK := Taller_CIC_IIoT_dataset_2025.ipynb

# Colores para output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Muestra este mensaje de ayuda
	@echo "$(GREEN)Comandos disponibles:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

setup: venv install check-env ## Configura el proyecto completo (crea venv e instala dependencias)
	@echo "$(GREEN)✓ Proyecto configurado correctamente$(NC)"

venv: ## Crea el entorno virtual de Python
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(YELLOW)Creando entorno virtual...$(NC)"; \
		$(PYTHON) -m venv $(VENV); \
		echo "$(GREEN)✓ Entorno virtual creado$(NC)"; \
	else \
		echo "$(YELLOW)El entorno virtual ya existe$(NC)"; \
	fi

install: venv ## Instala las dependencias del proyecto
	@echo "$(YELLOW)Instalando dependencias...$(NC)"
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQUIREMENTS)
	@echo "$(GREEN)✓ Dependencias instaladas$(NC)"

install-dev: install ## Instala dependencias incluyendo herramientas de desarrollo
	@echo "$(YELLOW)Instalando dependencias de desarrollo...$(NC)"
	@$(PIP) install jupyterlab ipykernel
	@$(PYTHON_VENV) -m ipykernel install --user --name=cic_iiot_2025 --display-name "Python (CIC IIoT 2025)"
	@echo "$(GREEN)✓ Dependencias de desarrollo instaladas$(NC)"
	@echo "$(YELLOW)Nota: El kernel de Jupyter está disponible como 'Python (CIC IIoT 2025)'$(NC)"

check-env: ## Verifica que el entorno esté configurado correctamente
	@echo "$(YELLOW)Verificando configuración...$(NC)"
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(RED)✗ El entorno virtual no existe. Ejecuta 'make setup' primero$(NC)"; \
		exit 1; \
	fi
	@if [ ! -f "$(REQUIREMENTS)" ]; then \
		echo "$(RED)✗ El archivo requirements.txt no existe$(NC)"; \
		exit 1; \
	fi
	@if [ ! -d "data/attack_data" ]; then \
		echo "$(YELLOW)⚠ Advertencia: El directorio data/attack_data no existe$(NC)"; \
	fi
	@if [ ! -d "data/benign_data" ]; then \
		echo "$(YELLOW)⚠ Advertencia: El directorio data/benign_data no existe$(NC)"; \
	fi
	@echo "$(GREEN)✓ Verificación completada$(NC)"

run-notebook: check-env ## Inicia Jupyter Notebook
	@echo "$(YELLOW)Iniciando Jupyter Notebook...$(NC)"
	@echo "$(GREEN)El notebook se abrirá en tu navegador$(NC)"
	@$(VENV_BIN)/jupyter notebook

run-lab: check-env ## Inicia JupyterLab
	@echo "$(YELLOW)Iniciando JupyterLab...$(NC)"
	@echo "$(GREEN)JupyterLab se abrirá en tu navegador$(NC)"
	@$(VENV_BIN)/jupyter lab

test: check-env ## Ejecuta tests básicos de verificación
	@echo "$(YELLOW)Ejecutando tests de verificación...$(NC)"
	@$(PYTHON_VENV) -c "import pandas; import numpy; import sklearn; import matplotlib; import seaborn; print('$(GREEN)✓ Todas las dependencias están instaladas correctamente$(NC)')"
	@echo "$(GREEN)✓ Tests completados$(NC)"

clean: ## Limpia archivos temporales y cache de Python
	@echo "$(YELLOW)Limpiando archivos temporales...$(NC)"
	@find . -type d -name "__pycache__" -exec rm -r {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type d -name "*.egg-info" -exec rm -r {} + 2>/dev/null || true
	@find . -type f -name ".DS_Store" -delete 2>/dev/null || true
	@echo "$(GREEN)✓ Limpieza completada$(NC)"

clean-all: clean ## Limpia todo incluyendo el entorno virtual
	@echo "$(YELLOW)Eliminando entorno virtual...$(NC)"
	@rm -rf $(VENV)
	@echo "$(GREEN)✓ Entorno virtual eliminado$(NC)"

update: ## Actualiza las dependencias
	@echo "$(YELLOW)Actualizando dependencias...$(NC)"
	@$(PIP) install --upgrade pip
	@$(PIP) install --upgrade -r $(REQUIREMENTS)
	@echo "$(GREEN)✓ Dependencias actualizadas$(NC)"

info: ## Muestra información del entorno
	@echo "$(GREEN)Información del proyecto:$(NC)"
	@echo "  Python: $(shell $(PYTHON) --version 2>/dev/null || echo 'No encontrado')"
	@if [ -d "$(VENV)" ]; then \
		echo "  Entorno virtual: $(GREEN)✓ Instalado$(NC)"; \
		echo "  Python en venv: $(shell $(PYTHON_VENV) --version 2>/dev/null || echo 'No disponible')"; \
	else \
		echo "  Entorno virtual: $(RED)✗ No instalado$(NC)"; \
	fi
	@echo "  Requirements: $(shell [ -f $(REQUIREMENTS) ] && echo '$(GREEN)✓$(NC)' || echo '$(RED)✗$(NC)')"
	@echo "  Notebook: $(shell [ -f $(NOTEBOOK) ] && echo '$(GREEN)✓$(NC)' || echo '$(RED)✗$(NC)')"
	@echo "  Directorio attack_data: $(shell [ -d data/attack_data ] && echo '$(GREEN)✓$(NC)' || echo '$(RED)✗$(NC)')"
	@echo "  Directorio benign_data: $(shell [ -d data/benign_data ] && echo '$(GREEN)✓$(NC)' || echo '$(RED)✗$(NC)')"

