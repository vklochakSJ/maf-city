# MAF-CITY — Інструкція запуску

## Структура файлів
```
maf-city/
├── index.html          ← Лендінг + форма входу/реєстрації
├── cabinet.html        ← Особистий кабінет
├── css/
│   └── style.css
├── js/
│   └── supabase.js
├── assets/
│   └── logo.jpg        ← Поклади сюди своє лого
└── supabase_schema.sql ← SQL для Supabase
```

---

## КРОК 1 — Supabase: створи таблиці

1. Відкрий https://supabase.com → твій проект
2. Ліве меню → **SQL Editor**
3. Натисни **New query**
4. Відкрий файл `supabase_schema.sql` і скопіюй весь вміст
5. Встав у редактор і натисни **Run**
6. Має з'явитись повідомлення Success

---

## КРОК 2 — Supabase: налаштуй Email Auth

1. Ліве меню → **Authentication** → **Providers**
2. Переконайся що **Email** увімкнено
3. **Authentication** → **URL Configuration**
4. У полі **Site URL** постав: `https://ВАШ_ЛОГІН.github.io/maf-city`
   (або тимчасово `http://localhost:3000`)
5. Збережи

---

## КРОК 3 — Підготуй файли

1. Поклади файл лого в папку `assets/logo.jpg`
2. Переконайся що структура папок відповідає схемі вище

---

## КРОК 4 — GitHub: завантаж сайт

1. Відкрий https://github.com → **New repository**
2. Назви його `maf-city`
3. Зроби **Public**
4. Натисни **Create repository**
5. Завантаж усі файли (кнопка **uploading an existing file**)
   Або через термінал:
   ```bash
   cd maf-city
   git init
   git add .
   git commit -m "init"
   git remote add origin https://github.com/ВАШ_ЛОГІН/maf-city.git
   git push -u origin main
   ```

---

## КРОК 5 — GitHub Pages: опублікуй

1. У репозиторії → **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** / **/ (root)**
4. Натисни **Save**
5. Через 1-2 хвилини сайт буде на:
   `https://ВАШ_ЛОГІН.github.io/maf-city`

---

## КРОК 6 — Оновити Site URL в Supabase

Після того як GitHub Pages дав тобі URL:
1. Supabase → **Authentication** → **URL Configuration**
2. **Site URL** → встав реальний URL з GitHub Pages
3. **Redirect URLs** → додай той самий URL + `/cabinet.html`
4. Збережи

---

## Готово! ✓

Сайт працює:
- `/index.html` — лендінг, реєстрація, вхід
- `/cabinet.html` — особистий кабінет з клубами

---

## Що робить кожна частина

| Функція | Де |
|---|---|
| Реєстрація / Вхід | index.html → модальне вікно |
| Профіль гравця | cabinet.html → Мій профіль |
| Мій клуб | cabinet.html → Мій клуб |
| Знайти клуб / подати заявку | cabinet.html → Знайти клуб |
| Створити клуб з лого | cabinet.html → кнопка «Створити клуб» |
| Прийняти/відхилити заявки | cabinet.html → Заявки (тільки адмін) |
| Учасники клубу | cabinet.html → Учасники (тільки адмін) |
| Передати права адміна | cabinet.html → Налаштування клубу |
| Змінити лого/назву клубу | cabinet.html → Налаштування клубу |
