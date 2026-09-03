# Server Stats Script

<!--toc:start-->
- [Server Stats Script](#server-stats-script)
  - [Commands](#commands)
  - [Getting Started](#getting-started)
<!--toc:end-->

A bash script to analyze server performance and

project: [link](https://github.com/jasael/devops-server-stats-script)
roadmap.sh project: [link](https://roadmap.sh/projects/server-stats)
This script check next information:

- OS System
- UPTIME
- CPU USAGE
- RAM USAGE
- DISK USAGE
- TOP 5 CPU USAGE PROCESSES
- TOP 5 MEMORY USAGE PROCESSES
- LOGGED IN USERS
- LAST 5 FAILED LOG IN

## Commands

- echo
- print
- awk
- tr
- top
- grep
- free
- df
- ps aux
- w
- lastb
- /etc/os-release
- sleep
- eval

## Getting Started

1. Clone the repository

    ```bash
    git clone https://github.com/jasael/server-performance-script.git
    cd server-performance-script
    ```

2. Make the script executable

    ```bash
    chmod +x ./server-stats.sh
    ```

3. Execute the script

    ```bash
    ./server-stats.sh
    ```
  
 
