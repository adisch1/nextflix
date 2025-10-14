const express = require('express');
const app = express();
const port = 3000;

// Simple route
app.get('/', (req, res) => {
  res.send('NextFlix App is running!');
});

app.listen(port, () => {
  console.log(`NextFlix app listening at http://localhost:${port}`);
});
