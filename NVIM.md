# PRD: VCS-ификация Neovim

> Этот документ — **стартовый prompt** для отдельного диалога с ИИ.
> Скопируй его целиком в новый чат, начни с фразы:
> "Помоги разобраться с миграцией моего nvim в VCS согласно этому PRD,
> начни с discovery".

---

## Контекст

Родительский проект — `~/projects/dotfiles` (macOS + Arch Linux, stow-based).
Стратегию см. в `STRATEGY.md` рядом. Nvim **намеренно вынесен** из основной
репы, потому что:

- `~/.config/nvim/` — форк **kickstart.nvim** и уже имеет собственный `.git`.
- Связь с upstream kickstart хочется сохранить (pullить обновления).
- Kickstart позиционируется как «форкни и правь под себя» — это отдельный жизненный
  цикл от основной dotfiles-репы.

## Текущее состояние (по состоянию на 2026-04-20)

```
~/.config/nvim/
├── .git/                     # уже есть локальный git (еще не запушен на GH)
├── .github/
├── .gitignore
├── .stylua.toml
├── init.lua                  # ~44K, расширенный kickstart
├── KICKSTART.md              # оригинальный ридми kickstart
├── LICENSE.md
├── README.md
├── doc/
├── lazy-lock.json
└── lua/
    ├── kickstart/            # оригинальные модули kickstart
    └── custom/               # мой слой
        ├── ai.lua            # конфиг AI-агентов (предположительно переключатель)
        ├── map.lua
        ├── options.lua
        └── plugins/
            ├── chatgpt.lua
            ├── codeium.lua
            ├── conform.lua
            ├── hlslens.lua
            ├── init.lua
            ├── langmap.lua
            ├── obsidian.lua
            ├── oil.lua
            ├── outline.lua
            ├── scrollbar.lua
            └── supermaven.lua
```

### Уже исключено / историческое

- `~/.config/nvim-chad`, `~/.config/nvim-kickstart`, `~/.config/nvim-lazy` — альтернативные
  сборки, по результатам сравнения победил kickstart. Не тащим.
- Связанные aliases в `~/.zshrc.local/nvim-chad.zsh`, `nvim-kickstart.zsh`, `nvim-lazyvim.zsh`
  — тоже удалить при миграции.

## Ограничения / Constraints

1. **Не сливаем в основную репу dotfiles.** Остаётся отдельной репой.
2. **Без nix.** Lazy.nvim для плагинов, mason для LSP/formatters.
3. **Сохранять upstream.** Должна быть возможность периодически делать
   `git fetch upstream && git merge`.
4. **Два AI-агента с переключением.** В `lua/custom/ai.lua` — механика переключения.
   Нужно удостовериться, что API-ключи (chatgpt, codeium, supermaven) читаются из
   env/файлов **вне репы** (см. `BW.md` в родительском проекте).
5. **Cross-platform:** должен запускаться и на macOS, и на Arch (treesitter,
   compile-tools etc. — через mason).
6. **Шрифты:** nerd-fonts нужны (сейчас на маке стоят `font-hack-nerd-font`,
   `font-iosevka-nerd-font` через brew). На Arch ставить через pacman.

## Открытые вопросы для ИИ-диалога

1. **Remote repo:** пушить как свой публичный форк `hmepas/nvim-kickstart` с правильным
   отношением к upstream (`nvim-lua/kickstart.nvim`)? Или приватно?
   Нужна понятная стратегия merge: какие файлы апстрима трогать нельзя, какие можно.

2. **Структура `lua/custom/plugins/`:** текущий файл-на-плагин — нормально. Или
   сгруппировать: `lua/custom/plugins/ai/{chatgpt,codeium,supermaven,init}.lua`?
   Оценить, как lazy.nvim подхватывает вложенные дири.

3. **AI-агенты и секреты:** разобрать `ai.lua`, понять схему переключения, вынести
   все `os.getenv("OPENAI_API_KEY")` в единый модуль `lua/custom/secrets.lua`
   который читает из env + из `~/.config/nvim/secrets.local.lua` (gitignored).
   Увязать с bw-materialize из родительского проекта.

4. **Lockfile:** `lazy-lock.json` — коммитим (закрепляем версии) или gitignore
   (всегда latest)? kickstart коммитит, я склонен согласиться.

5. **treesitter / LSP:** `:Lazy sync` + `:Mason` должны работать из коробки.
   Нужна проверка idempotent-bootstrap: клон → `nvim --headless "+Lazy! sync" +qa`.

6. **Обновление от upstream:** документировать процедуру
   (`git remote add upstream ...; git fetch upstream; git merge upstream/master`)
   — что ломается чаще всего и как откатывать.

7. **Миграция с текущей машины:** у локальной репы нет `origin`. Нужно:
   - создать пустую репу на GH,
   - добавить как `origin`,
   - добавить `upstream` на kickstart,
   - запушить.
   Все команды — в README репы nvim.

8. **Конфликт с обновлением плагинов:** supermaven vs codeium vs chatgpt —
   одновременно все три включены? Нужна ли deactivation-логика, или активен один
   по переменной среды.

## Discovery checklist для ИИ

Первым делом проверить:

- [ ] `cd ~/.config/nvim && git status && git log --oneline | head -20 && git remote -v`
- [ ] Прочитать `init.lua` секция `require('custom')` / `require('custom.plugins')`
- [ ] Прочитать `lua/custom/ai.lua` — понять механику переключения агентов
- [ ] Прочитать `lua/custom/plugins/{chatgpt,codeium,supermaven}.lua` — где читаются API-ключи
- [ ] Проверить `lua/custom/plugins/init.lua` (сейчас пустой `return {}` — значит, плагины
      подключаются не через него, а через imports в `lua/custom/init.lua`?)
- [ ] Посмотреть `:checkhealth` ожидания (LSP, treesitter, clipboard, python provider)
- [ ] Глянуть `lazy-lock.json` на суммарное число плагинов
- [ ] Сверить с оригинальным kickstart, насколько далеко ушёл форк

## Находки из dotfiles-base discovery (2026-04-21)

Что вскрылось при разборе секретов в `dotfiles-base/SECRETS.md` и было вынесено отсюда как nvim-specific:

### AI-плагины и их секреты

| Плагин | Репо | Конфиг в nvim | Секрет-файл в `~/` |
|---|---|---|---|
| Codeium / Windsurf | `Exafunction/windsurf.vim` | `lua/custom/plugins/codeium.lua` | `~/.windsurf-api-token` |
| ChatGPT | (вероятно `jackMort/ChatGPT.nvim`) | `lua/custom/plugins/chatgpt.lua` | `~/.neovim-chatgpt-api-key` |
| Supermaven | `supermaven-inc/supermaven-nvim` | `lua/custom/plugins/supermaven.lua` | (проверить при discovery) |

**NB:** Exafunction переименовали плагин `codeium.vim` → `windsurf.vim`, но локальный файл у меня всё ещё называется `codeium.lua`. Имя файла переименовывать при миграции не обязательно, но можно ради чистоты.

### Механика переключения (`lua/custom/ai.lua`)

- Строка 29: `pcall(lazy.load, { plugins = { 'windsurf.vim' } })` — lazy-load по требованию.
- `lua/custom/plugins/codeium.lua` при старте ставит:
  - `vim.g.codeium_disable_bindings = 1` — бинды не перехватываются (их повесит `custom.ai`).
  - `vim.g.codeium_enabled = 0` + `CodeiumDisable` — выключен по умолчанию, включается через переключатель.

Т.е. три AI-агента **не** активны одновременно. Схема: один активен через `custom.ai`, остальные выключены. Это снимает открытый вопрос №8 в PRD — deactivation-логика уже есть.

### Секрет-файлы — не в dotfiles-base

Эти ключи изначально были перечислены в `dotfiles-base/SECRETS.md`, но по факту нужны только для nvim-плагинов. Они перенесены **сюда** и должны быть описаны в `nvim/SECRETS.md`:

- `~/.windsurf-api-token` — Bitwarden: `windsurf-api-token` (проверить имя записи)
- `~/.neovim-chatgpt-api-key` — Bitwarden: `neovim-chatgpt` (в старом SECRETS.md было "дублирует OpenAI?" — проверить: если это тот же sk-ключ что и `~/.openai_key`, можно унифицировать)

Открытый вопрос: **`~/.openai_key` — dual-use?** Он лежит в `dotfiles-base/SECRETS.md` как "OpenAI API ключ". Используется CLI-тулзами (codex, что-то ещё?) и/или тем же ChatGPT.nvim? Если строго nvim — переехать сюда. Если dual-use — оставить в dotfiles-base и здесь только сослаться.

---

## Ожидаемый deliverable

1. `nvim/README.md` — установка на чистой машине, связь с upstream, как пулить апстрим.
2. `nvim/CUSTOM.md` — что добавлено поверх kickstart.
3. `nvim/SECRETS.md` — какие env нужны, куда складываются файлы с ключами (ссылка на
   родительский `BW.md`).
4. Запушенный форк на GH с правильно настроенным upstream.
5. Идемпотентная bootstrap-команда: `git clone … ~/.config/nvim && nvim --headless "+Lazy! sync" +qa`.
