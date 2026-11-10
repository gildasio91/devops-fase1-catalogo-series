const express = require('express');

const app = express();
app.use(express.json());

const series = [
  { id: 1, title: 'Breaking Bad', genre: 'Drama', seasons: 5 },
  { id: 2, title: 'The Office', genre: 'Comédia', seasons: 9 }
];

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', message: 'API funcionando' });
});

app.get('/series', (req, res) => {
  res.status(200).json(series);
});

app.get('/series/:id', (req, res) => {
  const item = series.find((serie) => serie.id === Number(req.params.id));
  if (!item) {
    return res.status(404).json({ error: 'Série não encontrada' });
  }
  return res.status(200).json(item);
});

app.post('/series', (req, res) => {
  const { title, genre, seasons } = req.body;

  if (
    typeof title !== 'string' || title.trim() === '' ||
    typeof genre !== 'string' || genre.trim() === '' ||
    !Number.isInteger(seasons) || seasons < 1
  ) {
    return res.status(400).json({
      error: 'Informe title, genre e seasons (inteiro maior que zero).'
    });
  }

  const newSeries = {
    id: series.length ? Math.max(...series.map((item) => item.id)) + 1 : 1,
    title: title.trim(),
    genre: genre.trim(),
    seasons
  };

  series.push(newSeries);
  return res.status(201).json(newSeries);
});

module.exports = app;
