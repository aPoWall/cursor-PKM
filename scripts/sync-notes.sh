#!/bin/bash

# Быстрая синхронизация заметок с GitHub

echo "🔄 Синхронизация заметок..."

# Проверка аргументов
if [ -z "$1" ]; then
    echo "❌ Ошибка: Укажите путь к папке Obsidian vault"
    echo "Использование: ./sync-notes.sh /путь/к/vault"
    exit 1
fi

VAULT_PATH="$1"
cd "$VAULT_PATH" || exit

# Проверка изменений
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ Нет изменений для синхронизации"

    # Попробовать получить изменения с GitHub
    echo "📥 Проверка обновлений на GitHub..."
    git pull

    if [ $? -eq 0 ]; then
        echo "✅ Синхронизация завершена!"
    else
        echo "⚠️  Ошибка при получении обновлений"
    fi
    exit 0
fi

# Показать статус
echo "📊 Измененные файлы:"
git status --short

# Добавить все изменения
git add .

# Получить текущую дату и время для коммита
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
COMMIT_MSG="Auto sync: $TIMESTAMP"

# Коммит
git commit -m "$COMMIT_MSG"

# Pull перед push (на случай конфликтов)
echo "📥 Получение обновлений с GitHub..."
git pull --rebase

if [ $? -ne 0 ]; then
    echo "⚠️  Обнаружены конфликты! Решите их вручную:"
    echo "   git status"
    echo "   # Отредактируйте конфликтующие файлы"
    echo "   git add ."
    echo "   git rebase --continue"
    echo "   git push"
    exit 1
fi

# Push
echo "📤 Отправка изменений на GitHub..."
git push

if [ $? -eq 0 ]; then
    echo "✅ Синхронизация успешно завершена!"
else
    echo "❌ Ошибка при отправке изменений"
    exit 1
fi
