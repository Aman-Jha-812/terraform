const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// Serve static HTML file from public folder
app.use(express.static(path.join(__dirname, 'public')));

app.get('/api', (req, res) => {
  res.json({ message: "Hello from Express frontend!" });
});

app.listen(PORT, () => {
  console.log(`Express frontend is running on http://localhost:${PORT}`);
});
