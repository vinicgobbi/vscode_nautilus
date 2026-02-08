# 📂 Nautilus VS Code Extension

> Uma extensão leve para o GNOME Nautilus que integra o **Visual Studio Code** ao menu de contexto, permitindo abrir arquivos e pastas rapidamente.

## ✨ Funcionalidades

* **Menu de Contexto Inteligente:**
* **Em arquivos/pastas:** Clique com botão direito em um item para abrir especificamente aquele projeto/arquivo.
* **No diretório atual:** Clique com botão direito no fundo da pasta (espaço vazio) para abrir o local atual no VS Code.

* **🌍 Idioma Dinâmico:** Detecta automaticamente o idioma do sistema operacional.
* 🇧🇷 **Português:** "Abrir com VS Code"
* 🇪🇸 **Espanhol:** "Abrir con VS Code"
* 🇺🇸 **Inglês (Padrão):** "Open with VS Code"

* **Compatibilidade Moderna:** Funciona perfeitamente com **Nautilus 43+ (GNOME 43 a 46)** e versões anteriores, resolvendo conflitos de namespaces (`Nautilus 3.0` vs `4.0`) automaticamente.
* **Execução Segura:** O processo do VS Code é desvinculado do Nautilus. Se você fechar o gerenciador de arquivos, seu editor continua aberto.

---

## 🚀 Instalação

Escolha o método que preferir. O método automático é recomendado pois verifica se você tem todas as dependências necessárias.

### Opção 1: Automática (Recomendada)

Baixe o script `install.sh` incluído no projeto e execute-o. Ele detectará sua distribuição, verificará dependências e instalará a extensão.

1. Dê permissão de execução e rode o script:

```bash
chmod +x install.sh
./install.sh

```

### Opção 2: Manual

Se preferir fazer passo a passo, siga as instruções abaixo:

1. **Instale as Dependências:**

A extensão requer o pacote `nautilus-python`. Instale conforme sua distribuição:

* **Ubuntu / Debian / Pop!_OS:** `sudo apt install python3-nautilus`
* **Fedora / RHEL:** `sudo dnf install nautilus-python`
* **Arch Linux / Manjaro:** `sudo pacman -S python-nautilus`

2. **Copie a Extensão:**

Crie o diretório de extensões local (se não existir) e copie o arquivo Python:

```bash
# Cria o diretório
mkdir -p ~/.local/share/nautilus-python/extensions

# Copie o arquivo (assumindo que você está na pasta do projeto)
cp vscode_nautilus.py ~/.local/share/nautilus-python/extensions/

```

3. **Reinicie o Nautilus:**

Para carregar a extensão, encerre o processo atual:

```bash
nautilus -q

```

---

## 🗑️ Desinstalação

Caso queira remover a extensão, você também pode optar pelo método automático ou manual.

### Opção 1: Automática

Se você usou o script de instalação, pode usá-lo para remover a extensão facilmente:

```bash
./install.sh --uninstall

```

### Opção 2: Manual

Basta remover o arquivo da extensão e reiniciar o Nautilus.

1. **Remova o arquivo:**

```bash
rm ~/.local/share/nautilus-python/extensions/vscode_nautilus.py

```

2. **Reinicie o Nautilus:**

```bash
nautilus -q

```

---

## 🛠️ Como Usar

1. Navegue até qualquer pasta no seu gerenciador de arquivos.
2. Clique com o **botão direito** em uma pasta, arquivo ou no espaço em branco.
3. Selecione a opção **"Abrir com VS Code"**.

---

## ❓ Solução de Problemas (Troubleshooting)

### A opção não aparece no menu

1. Verifique se o Nautilus foi reiniciado corretamente (`nautilus -q`).
2. Certifique-se de que o VS Code está instalado e acessível via terminal. Digite `code --version` no seu terminal. Se der erro, adicione o VS Code ao seu PATH.
3. Se você instalou o VS Code via **Flatpak**, o comando `code` pode não estar disponível diretamente.

### Erro: `Namespace Nautilus is already loaded with version 4.0`

Esta extensão possui um tratamento interno (`try/except`) para lidar com versões mistas do GNOME. Se você vir este aviso no terminal ao rodar o Nautilus manualmente, pode ignorá-lo; a extensão foi projetada para continuar funcionando mesmo com esse aviso.