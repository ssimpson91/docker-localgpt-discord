# Docker LocalGPT Discord

## Overview
This repository contains the necessary files and configurations to set up a Local GPT model for Discord. It includes scripts for crawling, ingesting data, and running the Local GPT model, as well as a Dockerfile for containerization.

## Contents

### Root Directory
- `Dockerfile`: Defines the Docker container configuration.
- `LICENSE`: The license file for the repository.
- `README.md`: Provides an overview and instructions for the repository.
- `constants.py`: Contains constant values used across the project.
- `crawl.py`: Script for crawling data.
- `ingest.py`: Script for ingesting data into the system.
- `load_models.py`: Script for loading GPT models.
- `prompt_template_utils.py`: Utility functions for prompt templates.
- `pyproject.toml`: Configuration file for Python projects.
- `requirements.txt`: Lists the Python dependencies for the project.
- `run_localGPT.py`: Script to run the Local GPT model.
- `run_localGPTL_API.py`: Script to run the Local GPT model with API.

### npm Directory
This directory contains the Node Package Manager (npm) configurations and dependencies for the project. It includes numerous subdirectories for various npm packages and modules. Some of the notable directories include:
- `node_modules`: Contains all the npm packages and dependencies required for the project.
- `@discordjs`: Contains modules related to Discord.js, a powerful Node.js module that allows interaction with the Discord API.
- `axios`: A promise-based HTTP client for making HTTP requests.
- `dotenv`: A module that loads environment variables from a `.env` file into `process.env`.
- `winston`: A logging library for Node.js.

## Functions
- Crawling and ingesting data for use with the Local GPT model.
- Running the Local GPT model in a Docker container for integration with Discord.
- Utilizing various npm packages for managing Discord interactions, HTTP requests, environment configurations, and logging.

## Usage Purposes
- To set up a Local GPT model for Discord using Docker for easy deployment and scalability.
- To provide scripts and configurations for crawling, ingesting, and running the Local GPT model.
- To manage interactions with Discord and handle various backend functionalities using npm packages.

---

Note: The npm directory contains a large number of subdirectories and modules. The above outline highlights some key directories for brevity. For a detailed exploration, it's recommended to browse the `npm` directory within the repository.
