# Синхронизация Obsidian + Claude Code + Mobile

## 🎯 Цель

Единая база знаний Obsidian, доступная из:
- **Desktop**: Claude Code в Cursor/терминале
- **Mobile**: Нативное приложение Claude (iOS/Android)
- **Web**: claude.ai

## 🏗️ Архитектура решения

```
┌─────────────────────────────────────────────────────────────────┐
│                         OBSIDIAN VAULT                          │
│                        (Dropbox + Git)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          GITHUB                                  │
│              (центральный хаб синхронизации)                     │
└─────────────────────────────────────────────────────────────────┘
          │                   │                    │
          ▼                   ▼                    ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────────┐
│   DESKTOP       │ │   CLAUDE.AI     │ │   MOBILE APP            │
│   Claude Code   │ │   Projects      │ │   Claude iOS/Android    │
│   (Cursor/Term) │ │   (Web)         │ │                         │
├─────────────────┤ ├─────────────────┤ ├─────────────────────────┤
│ • Полный доступ │ │ • Knowledge     │ │ • Доступ к Projects     │
│ • MCP плагины   │ │   Base          │ │ • Продолжение чатов     │
│ • .claude/      │ │ • RAG поиск     │ │ • Синхронизация чатов   │
│   CLAUDE.md     │ │ • Артефакты     │ │                         │
└─────────────────┘ └─────────────────┘ └─────────────────────────┘
```

## ⚠️ Важно понимать

### Что синхронизируется автоматически:
- ✅ Чаты claude.ai ↔ мобильное приложение
- ✅ Claude Projects и их Knowledge Base
- ✅ Артефакты и файлы в Projects

### Что НЕ синхронизируется:
- ❌ Локальные сессии Claude Code (`~/.claude/projects/`)
- ❌ Контекст `.claude/CLAUDE.md` (только локально)
- ❌ MCP серверы (только desktop)

## 🚀 Пошаговая настройка

### Шаг 1: Настройка Claude Project как центрального хаба

**На claude.ai (веб):**

1. Перейдите на [claude.ai](https://claude.ai)
2. Создайте новый Project: **"Obsidian PKM"**
3. В настройках Project добавьте **Custom Instructions**:

```markdown
Ты - мой AI ассистент для работы с персональной базой знаний (PKM).

## Контекст
- База знаний хранится в Obsidian vault
- Синхронизация через Git/GitHub
- Основные форматы: Markdown

## Твои задачи
1. Помогать с созданием и редактированием заметок
2. Искать информацию в загруженных документах
3. Создавать связи между темами
4. Генерировать сводки и отчеты

## Формат ответов
- Используй Markdown
- Добавляй [[wiki-ссылки]] для связей между заметками
- Используй теги #тег для категоризации
```

4. Загрузите ключевые файлы из Obsidian в Knowledge Base

### Шаг 2: Экспорт заметок для Claude Projects

Создайте скрипт для экспорта ключевых заметок:

```bash
# Запустите из корня Obsidian vault
./scripts/export-for-claude.sh
```

Скрипт создаст файл `_claude_export.md` со всеми заметками, который можно загрузить в Claude Project.

### Шаг 3: Настройка Claude Code на Desktop

**Создайте `.claude/CLAUDE.md` в вашем Obsidian vault:**

```markdown
# Obsidian PKM Context

## Структура vault
- /notes - основные заметки
- /projects - проекты
- /daily - ежедневные записи
- /templates - шаблоны

## Правила работы
1. При создании заметок использовать шаблоны из /templates
2. Добавлять теги для категоризации
3. Создавать связи через [[wiki-links]]
4. После изменений - git commit и push

## Текущие проекты
(обновляется автоматически)
```

### Шаг 4: Синхронизация через GitHub

**Workflow для поддержания синхронизации:**

```
DESKTOP (работа)
     │
     ▼
1. Редактирование в Obsidian/Claude Code
     │
     ▼
2. git add . && git commit && git push
     │
     ▼
3. Периодически: экспорт → загрузка в Claude Project
     │
     ▼
MOBILE (доступ)
     │
     ▼
4. Открыть Claude app → выбрать Project "Obsidian PKM"
     │
     ▼
5. Работать с контекстом из Knowledge Base
```

## 📱 Работа с мобильного

### В Claude iOS/Android app:

1. **Откройте приложение Claude**
2. **Выберите Project** "Obsidian PKM"
3. **Задавайте вопросы** по вашим заметкам:
   - "Найди все заметки о [тема]"
   - "Создай сводку по проекту X"
   - "Что я записывал о [тема] на прошлой неделе?"

### Ограничения мобильной версии:
- Нельзя редактировать Knowledge Base
- Нельзя создавать новые Projects
- Результаты нужно сохранять вручную

### Workaround для редактирования:
```
Mobile: "Создай заметку о [тема] в формате markdown"
     │
     ▼
Скопировать ответ
     │
     ▼
Desktop: Вставить в Obsidian → git push
```

## 🔄 Продвинутая синхронизация

### Вариант 1: Claude Code Web (бета)

Claude Code теперь доступен в веб-версии:

```bash
# В терминале Claude Code
& "Проанализируй мои заметки и создай сводку"
```

Префикс `&` отправляет задачу в облако, и вы можете:
- Следить за выполнением с мобильного
- Продолжить работу позже

### Вариант 2: Happy Coder (open-source)

[Happy Coder](https://happy.engineering/) - бесплатное решение для синхронизации Claude Code с мобильным:

```bash
npm install -g happy-coder
happy-coder start
```

Возможности:
- Real-time синхронизация между CLI и мобильным
- End-to-end шифрование
- Двунаправленная связь

### Вариант 3: Экспорт сессий

Установите инструмент для экспорта:

```bash
pip install claude-conversation-extractor
```

Экспортируйте важные сессии:

```bash
claude-conversation-extractor --format markdown --output ~/Dropbox/ObsidianVault/claude-sessions/
```

Теперь сессии сохраняются в Obsidian и доступны везде!

## 📋 Практические команды

### На Desktop (Claude Code в Cursor/терминале):

```
"Создай заметку о [тема] и сохрани в GitHub"
"Найди все заметки с тегом #работа"
"Обнови индекс заметок"
"Экспортируй заметки для Claude Project"
```

### На Mobile (Claude app):

```
"Найди в моих заметках информацию о [тема]"
"Создай план на основе проекта X"
"Сделай сводку по [категория]"
"Подготовь текст заметки о [тема] в markdown"
```

## 🛠️ Автоматизация

### Cron job для автоматического экспорта:

```bash
# Добавьте в crontab -e
0 */6 * * * cd ~/Dropbox/ObsidianVault && ./scripts/export-for-claude.sh
```

### Git hook для автоматического обновления:

```bash
# .git/hooks/post-commit
#!/bin/bash
./scripts/export-for-claude.sh
echo "Claude export updated"
```

## 🎯 Best Practices

### 1. Структурируйте заметки для AI
```markdown
---
tags: [проект, важное]
date: 2025-01-09
---

# Заголовок

## Контекст
...

## Ключевые моменты
- Пункт 1
- Пункт 2

## Связанные заметки
- [[Заметка 1]]
- [[Заметка 2]]
```

### 2. Регулярно обновляйте Claude Project
- После крупных изменений в vault
- Минимум раз в неделю
- Удаляйте устаревшие файлы из Knowledge Base

### 3. Используйте теги последовательно
- `#inbox` - для обработки
- `#проект/название` - для проектов
- `#тип/заметка` - для типов контента

### 4. Создавайте индексные заметки
Файл `_INDEX.md` со ссылками на ключевые заметки - загрузите его первым в Claude Project.

## 🔗 Полезные ресурсы

- [Claude Projects Documentation](https://support.claude.com/en/articles/9517075-what-are-projects)
- [Obsidian Git Plugin](https://github.com/denolehov/obsidian-git)
- [Claude Conversation Extractor](https://github.com/ZeroSumQuant/claude-conversation-extractor)
- [Obsidian MCP Plugin](https://github.com/iansinnott/obsidian-claude-code-mcp)
- [Happy Coder Mobile](https://happy.engineering/)

## ❓ FAQ

**Q: Могу ли я редактировать заметки с мобильного через Claude?**
A: Напрямую нет. Но можно попросить Claude сгенерировать текст, скопировать его, и добавить через Obsidian Mobile или git.

**Q: Как часто обновлять Knowledge Base?**
A: Зависит от интенсивности работы. Рекомендую: после каждой значимой сессии или минимум раз в неделю.

**Q: Синхронизируются ли сессии Claude Code автоматически?**
A: Нет. Локальные сессии (~/.claude/projects/) остаются на устройстве. Используйте экспорт для сохранения важных разговоров.

**Q: Можно ли использовать MCP на мобильном?**
A: Пока нет. MCP работает только на desktop (Claude Code CLI, Claude Desktop app).
