#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ---------------------------------------------------------
# Configuração de Caminhos
# ---------------------------------------------------------

# Diretório onde este script está rodando
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_FILE="$SCRIPT_DIR/vscode_nautilus.py"

# Diretório de destino
TARGET_DIR="$HOME/.local/share/nautilus-python/extensions"
TARGET_FILE="$TARGET_DIR/vscode_nautilus.py"

# ---------------------------------------------------------
# 1. Modo Desinstalação (--uninstall)
# ---------------------------------------------------------
if [[ "$1" == "--uninstall" ]]; then
    echo -e "${BLUE}=== Desinstalação: Nautilus VS Code Extension ===${NC}\n"
    if [ -f "$TARGET_FILE" ]; then
        echo -e "Removendo: ${YELLOW}$TARGET_FILE${NC}"
        rm "$TARGET_FILE"
        echo -e "${BLUE}Reiniciando o Nautilus...${NC}"
        nautilus -q
        echo -e "\n${GREEN}✅ Extensão removida com sucesso!${NC}"
    else
        echo -e "${YELLOW}⚠️  A extensão não foi encontrada.${NC}"
    fi
    exit 0
fi

# ---------------------------------------------------------
# 2. Verificação de Integridade do Projeto
# ---------------------------------------------------------
if [ ! -f "$SOURCE_FILE" ]; then
    echo -e "${RED}❌ Erro Crítico: Arquivo fonte não encontrado!${NC}"
    echo -e "O arquivo ${YELLOW}vscode_nautilus.py${NC} precisa estar na mesma pasta deste script."
    exit 1
fi

# ---------------------------------------------------------
# 3. Verificação de Ambiente (Runtime Check)
# ---------------------------------------------------------
MISSING_DEPS=()

echo -e "${BLUE}=== Instalação: Verificação de Dependências ===${NC}\n"

# 3.1 Python 3
if ! command -v python3 &> /dev/null; then
    MISSING_DEPS+=("python3 (Interpretador)")
fi

# 3.2 VS Code
if ! command -v code &> /dev/null; then
    MISSING_DEPS+=("code (Visual Studio Code no PATH)")
fi

# 3.3 PyGObject (Verificação via Python Import)
# Esta é a correção principal: Pergunta ao Python se o módulo existe, em vez de perguntar ao pkg-config
if command -v python3 &> /dev/null; then
    if ! python3 -c "import gi" &> /dev/null; then
        MISSING_DEPS+=("python3-gobject (Módulo 'gi' do Python)")
    fi
fi

# 3.4 Nautilus-Python (Verificação Híbrida)
# Tenta verificar se a biblioteca está carregada no cache do ldconfig ou via gerenciador de pacotes
HAS_NAUTILUS_PYTHON=false

# Método A: pkg-config (Ideal, mas requer pacote -devel)
if command -v pkg-config &> /dev/null && pkg-config --exists nautilus-python; then
    HAS_NAUTILUS_PYTHON=true
# Método B: Verificar pacotes instalados (Fallback robusto para usuários)
elif [ -f /etc/debian_version ] && dpkg -s python3-nautilus &> /dev/null; then
    HAS_NAUTILUS_PYTHON=true
elif [ -f /etc/fedora-release ] && rpm -q nautilus-python &> /dev/null; then
    HAS_NAUTILUS_PYTHON=true
elif [ -f /etc/arch-release ] && pacman -Q python-nautilus &> /dev/null; then
    HAS_NAUTILUS_PYTHON=true
# Método C: Verificar biblioteca compartilhada comum (Último recurso)
elif ldconfig -p 2>/dev/null | grep -q "libnautilus-python"; then
    HAS_NAUTILUS_PYTHON=true
fi

if [ "$HAS_NAUTILUS_PYTHON" = false ]; then
    MISSING_DEPS+=("nautilus-python (Biblioteca de extensão do Nautilus)")
fi

# ---------------------------------------------------------
# 4. Relatório de Falhas
# ---------------------------------------------------------
if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}❌ Dependências em falta:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        echo -e "   - ${YELLOW}$dep${NC}"
    done
    
    echo -e "\n${BLUE}ℹ️  Sugestão de correção:${NC}"
    if [ -f /etc/debian_version ]; then
        echo "   sudo apt install python3-nautilus python3-gi"
    elif [ -f /etc/fedora-release ]; then
        echo "   sudo dnf install nautilus-python python3-gobject"
    elif [ -f /etc/arch-release ]; then
        echo "   sudo pacman -S python-nautilus python-gobject"
    else
        echo "   Instale os pacotes 'python-nautilus' e 'python-gobject' (ou gi)."
    fi
    exit 1
fi

# ---------------------------------------------------------
# 5. Instalação
# ---------------------------------------------------------

echo -e "${GREEN}✅ Dependências OK!${NC}"
echo -e "Criando diretório: ${YELLOW}$TARGET_DIR${NC}"
mkdir -p "$TARGET_DIR"

echo -e "Copiando extensão..."
cp "$SOURCE_FILE" "$TARGET_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Arquivo copiado com sucesso.${NC}"
else
    echo -e "${RED}Falha ao copiar o arquivo.${NC}"
    exit 1
fi

echo -e "${BLUE}Reiniciando Nautilus...${NC}"
nautilus -q

echo -e "\n${GREEN}🎉 Instalação concluída!${NC}"