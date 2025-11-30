const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

// PostgreSQL connection pool using environment variable
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Array of inspirational quotes
const quotes = [
  "The only way to do great work is to love what you do.",
  "Innovation distinguishes between a leader and a follower.",
  "Stay hungry, stay foolish.",
  "Code is like humor. When you have to explain it, it's bad.",
  "First, solve the problem. Then, write the code.",
  "Experience is the name everyone gives to their mistakes.",
  "Simplicity is the soul of efficiency.",
  "Make it work, make it right, make it fast.",
  "The best error message is the one that never shows up.",
  "Programming isn't about what you know; it's about what you can figure out."
];

// Initialize database table
async function initDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS quotes (
        id SERIAL PRIMARY KEY,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        quote TEXT NOT NULL
      )
    `);
    console.log('✓ Database table initialized');
    
    // Test database write capability
    await pool.query('SELECT 1');
    console.log('✓ Database connection is healthy and writable');
  } catch (err) {
    console.error('✗ Error initializing database:', err);
    console.error('✗ Database is not writable!');
  }
}

// Initialize database on startup
initDatabase();

// Add-line endpoint
app.post('/add-line', async (req, res) => {
  const requestId = Math.random().toString(36).substring(7);
  console.log(`[${requestId}] Received POST /add-line request`);
  
  try {
    // Get a random quote
    const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
    
    // Insert into database
    const result = await pool.query(
      'INSERT INTO quotes (quote) VALUES ($1) RETURNING id, timestamp, quote',
      [randomQuote]
    );
    
    console.log(`[${requestId}] ✓ Quote added successfully:`, {
      id: result.rows[0].id,
      timestamp: result.rows[0].timestamp,
      quote: result.rows[0].quote
    });
    
    res.status(201).json({
      success: true,
      data: result.rows[0]
    });
  } catch (err) {
    console.error(`[${requestId}] ✗ Error adding quote:`, err);
    res.status(500).json({
      success: false,
      error: 'Failed to add quote - database not writable'
    });
  }
});

// Get all quotes endpoint
app.get('/quotes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM quotes ORDER BY timestamp DESC');
    res.json({
      success: true,
      count: result.rows.length,
      data: result.rows
    });
  } catch (err) {
    console.error('Error fetching quotes:', err);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch quotes'
    });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
