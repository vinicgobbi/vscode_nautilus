import os
import locale
import subprocess
import gi

try:
    gi.require_version('Nautilus', '4.0') # Tenta Carregar a versão 4.0
except ValueError:
    pass # Caso falhe ele deixa passar normalmente

from gi.repository import Nautilus, GObject

class VSCodeExtension(GObject.GObject, Nautilus.MenuProvider):
    
    def __init__(self):
        # Configuração de idioma com fallback seguro
        try:
            self.current_lang = locale.getlocale()[0]
        except:
            self.current_lang = 'en_US'
            
        self.translations = {
            'pt_BR': {
                'label': 'Abrir com VS Code',
                'tip': 'Abre no Visual Studio Code'
            },
            'es_ES': {
                'label': 'Abrir con VS Code',
                'tip': 'Abre en Visual Studio Code'
            },
            'default': {
                'label': 'Open with VS Code',
                'tip': 'Open in Visual Studio Code'
            }
        }

    def _t(self, key):
        """Busca tradução baseada no locale."""
        lang_dict = self.translations.get(self.current_lang, self.translations['default'])
        return lang_dict.get(key, self.translations['default'][key])

    def launch_vscode(self, menu, files):
        """Lança o processo do VS Code de forma segura."""
        for file in files:
            filepath = file.get_location().get_path()
            if filepath:
                # Define o diretório de trabalho (CWD) corretamente
                # Se for arquivo, usa a pasta pai. Se for pasta, usa ela mesma.
                work_dir = filepath if os.path.isdir(filepath) else os.path.dirname(filepath)
                
                # Executa desvinculado do processo do Nautilus
                subprocess.Popen(['code', filepath], cwd=work_dir)

    def get_file_items(self, *args):
        """Menu de contexto para arquivos/pastas selecionados."""
        files = args[-1] if args else []
        
        if not files:
            return
        
        item = Nautilus.MenuItem(
            name='VSCodeExtension::OpenFile',
            label=self._t('label'),
            tip=self._t('tip')
        )
        item.connect('activate', self.launch_vscode, files)
        return [item]

    def get_background_items(self, *args):
        """Menu de contexto para o fundo da pasta (espaço vazio)."""
        file = args[-1] if args else None
        
        if not file:
            return

        item = Nautilus.MenuItem(
            name='VSCodeExtension::OpenBackground',
            label=self._t('label'),
            tip=self._t('tip')
        )
        # Passa como lista para manter compatibilidade com a função launch_vscode
        item.connect('activate', self.launch_vscode, [file])
        return [item]