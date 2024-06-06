const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, 'app')));

app.get('/', (req, res) => {
  res.send('Welcome to the Tic Tac Toe API!');
});

app.get('/game', (req, res) => {
  res.sendFile(path.join(__dirname, 'app', 'index.html'));
});

app.get('/healthz', (req, res) => {
  
  const isHealthy = true; 

  if (isHealthy) {
    res.status(200).send('OK');
  } else {
    res.status(500).send('Unhealthy');
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});