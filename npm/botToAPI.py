const { Client, GatewayIntentBits } = require('discord.js');
const { token } = require('./config.json');
const winston = require('winston');
const axios = require('axios');

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
    const userMessage = message.content.slice(PREFIX.length);

    try {
      // Make a POST request to the LocalGPT API with the user's message
      const response = await axios.post('http://127.0.0.1:5110/api/receive_user_prompt', {
        user_prompt: userMessage,
      });

      // Extract the response from the API and send it back to the user
      const botResponse = response.data.Answer;
      console.log('Bot response:', botResponse);
      logger.info('Bot response:', botResponse);
      message.channel.send(botResponse);
    } catch (error) {
      // Handle any errors that occur during the API request
      console.error('Error communicating with LocalGPT API:', error.message);
      logger.error('Error communicating with LocalGPT API:', error.message);
      message.channel.send('An error occurred while processing your request.');
    }
  }
});

// Add event handlers and functionality for your bot here

client.login(token);
