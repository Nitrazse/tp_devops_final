const express = require('express');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
app.use(express.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'mysql',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'lacesdb'
});

db.connect((err) => {
  if (err) {
    console.error('Erreur connexion DB:', err);
  } else {
    console.log('Connecté à MySQL !');
  }
});

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'API Lacets Connectés 👟' });
});

app.get('/laces', (req, res) => {
  db.query('SELECT * FROM laces', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post('/laces', (req, res) => {
  const { name, color, size } = req.body;
  db.query('INSERT INTO laces (name, color, size) VALUES (?, ?, ?)',
    [name, color, size],
    (err, result) => {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ id: result.insertId, name, color, size });
    }
  );
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});