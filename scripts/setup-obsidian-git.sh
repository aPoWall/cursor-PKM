#!/bin/bash

# Скрипт для первоначальной настройки Git в Obsidian vault

echo "🚀 Настройка Git для Obsidian vault"
echo ""

# Проверка аргументов
if [ -z "$1" ]; then
    echo "❌ Ошибка: Укажите путь к папке Obsidian vault"
    echo "Использование: ./setup-obsidian-git.sh /путь/к/vault"
    echo "Пример: ./setup-obsidian-git.sh ~/Dropbox/ObsidianVault"
    exit 1
fi

VAULT_PATH="$1"

# Проверка существования папки
if [ ! -d "$VAULT_PATH" ]; then
    echo "❌ Ошибка: Папка $VAULT_PATH не существует"
    exit 1
fi

echo "📁 Vault путь: $VAULT_PATH"
cd "$VAULT_PATH" || exit

# Проверка, не инициализирован ли уже Git
if [ -d ".git" ]; then
    echo "⚠️  Git репозиторий уже существует"
    echo "Хотите продолжить? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
        echo "Отменено"
        exit 0
    fi
else
    # Инициализация Git
    echo "🔧 Инициализация Git репозитория..."
    git init
fi

# Копирование .gitignore
echo "📝 Создание .gitignore..."
if [ -f ".gitignore" ]; then
    echo "⚠️  .gitignore уже существует, создаем резервную копию"
    cp .gitignore .gitignore.backup
fi

cat > .gitignore << 'EOF'
# Obsidian настройки (персональные)
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/workspaces.json
.obsidian/hotkeys.json
.obsidian/app.json
.obsidian/appearance.json

# Obsidian кэш
.obsidian/cache

# Системные файлы
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
*.tmp

# Dropbox файлы
.dropbox
.dropbox.attr
.dropbox.cache

# Конфликтные копии Dropbox
*conflicted copy*

# Временные файлы
~$*
*.swp
*.swo
*~
EOF

# Первый коммит
echo "💾 Создание первого коммита..."
git add .
git commit -m "Initial commit: Obsidian vault setup"

echo ""
echo "✅ Git успешно настроен!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Создайте репозиторий на GitHub"
echo "2. Выполните следующие команды:"
echo ""
echo "   git remote add origin https://github.com/USERNAME/REPO.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. (Опционально) Установите плагин Obsidian Git в Obsidian"
echo ""
