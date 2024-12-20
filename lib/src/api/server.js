const express = require('express');
const bodyParser = require('body-parser');

// Инициализация приложения Express
const app = express();
const port = 53000;

// Настроим body-parser для работы с JSON
app.use(bodyParser.json());

// Заглушка для категорий
const categories = [
  {
    name: "Здоровье",
    emoji: "💪",
    subCategories: [
      { name: "Йога", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" },
      { name: "Врач", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" }
    ]
  },
  {
    name: "Science",
    emoji: "🔬",
    subCategories: [
      { name: "Тренер", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" },
      { name: "Рецепты", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" }
    ]
  },
  {
    name: "Образование",
    emoji: "📚",
    subCategories: [
      { name: "Тренер", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" },
      { name: "Коуч", description: "Йога - это отличный способ улучшить своё здоровье и настроение!" }
    ]
  }
];

// Обработчик для получения категорий
app.get('/categories', (req, res) => {
  res.json(categories);
});

// Обработчик для отправки сообщений в чат
app.post('/chat/send_message', (req, res) => {
  const { message } = req.body;

  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  // Для примера, всегда отвечаем, что самая длинная река — это Нил
  const response = {
    message: 'Самая длинная река в мире — река Нил...'
  };

  res.json(response);
});

// Запуск сервера
app.listen(53000, '10.0.2.2', () => {
    console.log(`Server is running at http://10.0.2.2:53000`);
});
