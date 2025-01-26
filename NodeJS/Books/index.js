//https://www.abibliadigital.com.br/api/books


const express = require('express');
const axios = require('axios'); // Import axios for making HTTP requests
var cors = require('cors')

const app = express();
const port = 3001;


app.use(cors())


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
})


var apiURL = "https://openlibrary.org/people/mekBot/books/want-to-read.json"


app.get('/', (req, res) => {
    res.send('Hello, world <---> Books Microservice 7071!');
});

// Fetch all books from the external API
app.get('/books', async (req, res) => {
  try {
    const response = await axios.get(apiURL);
    const books = response.data; // Extract data from the response
    res.json(books); // Send the books data as JSON response
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching books data');
  }
});


