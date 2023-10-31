const { Client, GatewayIntentBits } = require('discord.js');
const { token } = require('./config.json');
const winston = require('winston');
const axios = require('axios');
const fs = require('fs'); // Import the 'fs' module

// Create a logger instance
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.printf(({ level, message, timestamp }) => {
      return `${timestamp} [${level.toUpperCase()}]: ${message}`;
    })
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'discord_bot.log' }) // Log to a file named discord_bot.log
  ]
});

const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

client.once('ready', () => {
  console.log(`Logged in as ${client.user.tag}!`);
  logger.info(`Logged in as ${client.user.tag}!`);
});

const PREFIX = '!chat ';

client.on('messageCreate', async message => {
  // Log the received message object for debugging
  console.log('Received message:', message);
  logger.info('Received message:', message.content);

  // Ignore messages from bots to avoid potential loops
  if (message.author.bot) return;

  // Check if the message starts with the command prefix (e.g., '!chat ')
  if (message.content.startsWith(PREFIX)) {
    // Extract the user's message (excluding the command prefix)
    const userPrompt = message.content.slice(PREFIX.length).trim();

    try {
      const response = await axios.post('http://172.17.0.2:5110/api/receive_user_prompt', {
        user_prompt: userPrompt
      });

      const promptResponse = response.data;

      // Check if the response is too long for a single Discord message
      if (promptResponse.Answer.length > 2000) {
        // Save the response to a text file
        fs.writeFileSync('response.txt', promptResponse.Answer);

        // Send the text file to the Discord channel
        message.channel.send({
          files: [{
            attachment: 'response.txt',
            name: 'response.txt'
          }]
        });
      } else {
        // Send the response as a regular message
        message.channel.send(promptResponse.Answer);
      }
    } catch (error) {
      console.error(`Error sending user prompt to LocalGPT API: ${error}`);
    }
  }
});

client.login(token);