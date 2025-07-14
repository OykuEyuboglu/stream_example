

const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());

app.get('/random-stream', (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const interval = setInterval(() => {
    const randomNumber = Math.floor(Math.random() * 100);
    res.write(`data: ${randomNumber}\n\n`);
  }, 1000);

  req.on('close', () => {
    clearInterval(interval);
    res.end();
  });
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
