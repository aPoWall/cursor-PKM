# 🚀 Быстрый старт: Obsidian + Git + AI инструменты

## 5-минутная настройка

### Шаг 1: Подготовьте Obsidian vault

```bash
# Перейдите в вашу папку Obsidian (в Dropbox)
cd ~/Dropbox/ObsidianVault  # Замените на ваш путь

# Проверьте что вы в правильной папке
ls -la
# Должны увидеть папку .obsidian и ваши заметки
```

### Шаг 2: Инициализируйте Git

```bash
# Инициализация
git init

# Скопируйте .gitignore из этого репозитория
# Или используйте готовый скрипт:
curl -o .gitignore https://raw.githubusercontent.com/YOURNAME/cursor-PKM/main/templates/obsidian-gitignore

# ИЛИ создайте вручную (см. OBSIDIAN_MULTI_TOOL_SETUP.md)
```

### Шаг 3: Первый коммит

```bash
git add .
git commit -m "Initial commit: Obsidian vault"
```

### Шаг 4: Создайте репозиторий на GitHub

1. Перейдите на https://github.com
2. Нажмите "New repository"
3. Название: `obsidian-vault` или `my-notes`
4. **НЕ** добавляйте README, .gitignore, license
5. Нажмите "Create repository"

### Шаг 5: Подключите к GitHub

```bash
# Используйте команды с GitHub (они будут показаны после создания репозитория)
git remote add origin https://github.com/USERNAME/obsidian-vault.git
git branch -M main
git push -u origin main
```

### Шаг 6: Настройте инструменты

#### Obsidian

1. Settings → Community plugins → Browse
2. Найдите **"Obsidian Git"**
3. Install → Enable
4. Settings → Obsidian Git:
   - Auto backup: ON (10 minutes)
   - Auto pull: ON (5 minutes)

#### Windsurf

```bash
# Откройте папку в Windsurf
windsurf ~/Dropbox/ObsidianVault
```

#### VS Code + Cline

```bash
# Откройте папку в VS Code
code ~/Dropbox/ObsidianVault

# Установите расширение Cline
```

#### Claude Code

```bash
# Перейдите в папку
cd ~/Dropbox/ObsidianVault

# Или склонируйте из GitHub на другом устройстве
git clone https://github.com/USERNAME/obsidian-vault.git
```

---

## ✅ Готово! Теперь попробуйте:

### Тест 1: Создание заметки

**В Obsidian:**
1. Создайте новую заметку "Test"
2. Напишите что-нибудь
3. Подождите 10 минут (автокоммит) ИЛИ нажмите Ctrl+P → "Obsidian Git: Commit all changes"

**Проверка:**
```bash
git log --oneline -3
# Должен появиться новый коммит
```

### Тест 2: Синхронизация между инструментами

1. **Obsidian:** Создайте заметку "Test 2"
2. **Obsidian Git:** Commit + Push
3. **Windsurf:** Откройте другой терминал, сделайте `git pull`
4. Заметка "Test 2" должна появиться в Windsurf!

### Тест 3: Работа с AI

**В Claude Code / Windsurf / Cline:**
```
Создай заметку "Тестирование AI" с содержимым:
- Проверка работы AI
- Интеграция работает
- Все отлично!
```

**Проверка в Obsidian:**
- Обновите Obsidian (Ctrl+P → "Obsidian Git: Pull")
- Заметка должна появиться!

---

## 📋 Ежедневный Workflow

### Утро:
```bash
# В терминале
cd ~/Dropbox/ObsidianVault
git pull
```

### В течение дня:
- Работайте в Obsidian (автоматические коммиты каждые 10 минут)
- Или используйте AI инструменты для создания/редактирования заметок

### Вечер:
```bash
# Убедитесь что все отправлено на GitHub
git status
git push  # Если есть что пушить
```

---

## 🆘 Частые проблемы

### "Your branch is behind"

```bash
git pull
# Если конфликты - см. OBSIDIAN_MULTI_TOOL_SETUP.md
```

### "Changes not staged for commit"

```bash
git add .
git commit -m "Update notes"
git push
```

### "Конфликты при pull"

```bash
# Посмотрите какой файл
git status

# Откройте файл, найдите:
# <<<<<<< HEAD
# Ваша версия
# =======
# Версия с GitHub
# >>>>>>> origin/main

# Выберите нужную версию, удалите метки
# Потом:
git add .
git commit -m "Resolve conflict"
git push
```

---

## 🎓 Дальнейшее обучение

1. **Полное руководство:** `OBSIDIAN_MULTI_TOOL_SETUP.md`
2. **Команды для AI:** `AI_COMMANDS_CHEATSHEET.md`
3. **Скрипты:** папка `scripts/`

---

## 💬 Нужна помощь?

Спросите у любого AI инструмента:

```
Помоги настроить Obsidian с Git
Как синхронизировать заметки между устройствами?
Что делать при конфликте в Git?
```

---

**Все готово! Начинайте использовать систему!** 🎉
