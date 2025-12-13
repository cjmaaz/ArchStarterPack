#!/usr/bin/env bash

# ============================================
# Practice Menu - Command Selection Interface
# ============================================
# Main entry point for practice system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

show_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                ║${NC}"
    echo -e "${BLUE}║      ${CYAN}Interactive Shell Commands Practice System${BLUE}            ║${NC}"
    echo -e "${BLUE}║                                                                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_main_menu() {
    show_header
    echo -e "${YELLOW}Select a Category:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} Text Processing (8 commands)"
    echo -e "${GREEN}2.${NC} File Operations (7 commands)"
    echo -e "${GREEN}3.${NC} Data Processing (4 commands)"
    echo -e "${GREEN}4.${NC} Archives (3 commands)"
    echo -e "${GREEN}5.${NC} Network (4 commands)"
    echo -e "${GREEN}6.${NC} System (4 commands)"
    echo -e "${GREEN}7.${NC} Utilities (5 commands)"
    echo ""
    echo -e "${CYAN}8.${NC} View Progress"
    echo -e "${CYAN}9.${NC} About Practice System"
    echo -e "${RED}q.${NC} Quit"
    echo ""
    read -p "Choose option: " choice
    echo ""

    case "$choice" in
        1) show_text_menu ;;
        2) show_file_menu ;;
        3) show_data_menu ;;
        4) show_archive_menu ;;
        5) show_network_menu ;;
        6) show_system_menu ;;
        7) show_utils_menu ;;
        8) ./progress.sh show; read -p "Press Enter..."; show_main_menu ;;
        9) show_about; read -p "Press Enter..."; show_main_menu ;;
        q|Q) exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1; show_main_menu ;;
    esac
}

show_text_menu() {
    show_header
    echo -e "${YELLOW}Text Processing Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} grep - Pattern matching (15 exercises)"
    echo -e "${GREEN}2.${NC} awk - Field processing (15 exercises)"
    echo -e "${GREEN}3.${NC} sed - Stream editing (15 exercises)"
    echo -e "${GREEN}4.${NC} cut - Column extraction (12 exercises)"
    echo -e "${GREEN}5.${NC} sort - Sorting (12 exercises)"
    echo -e "${GREEN}6.${NC} uniq - Remove duplicates (10 exercises)"
    echo -e "${GREEN}7.${NC} wc - Count lines/words/bytes (10 exercises)"
    echo -e "${GREEN}8.${NC} tr - Transform characters (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/grep-practice.sh ;;
        2) ./commands/awk-practice.sh ;;
        3) ./commands/sed-practice.sh ;;
        4) ./commands/cut-practice.sh ;;
        5) ./commands/sort-practice.sh ;;
        6) ./commands/uniq-practice.sh ;;
        7) ./commands/wc-practice.sh ;;
        8) ./commands/tr-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_text_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_text_menu
}

show_file_menu() {
    show_header
    echo -e "${YELLOW}File Operations Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} cat - View files (10 exercises)"
    echo -e "${GREEN}2.${NC} head - First N lines (10 exercises)"
    echo -e "${GREEN}3.${NC} tail - Last N lines (12 exercises)"
    echo -e "${GREEN}4.${NC} find - Search files (15 exercises)"
    echo -e "${GREEN}5.${NC} diff - Compare files (10 exercises)"
    echo -e "${GREEN}6.${NC} tee - Split output (10 exercises)"
    echo -e "${GREEN}7.${NC} chmod - Change permissions (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/cat-practice.sh ;;
        2) ./commands/head-practice.sh ;;
        3) ./commands/tail-practice.sh ;;
        4) ./commands/find-practice.sh ;;
        5) ./commands/diff-practice.sh ;;
        6) ./commands/tee-practice.sh ;;
        7) ./commands/chmod-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_file_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_file_menu
}

show_data_menu() {
    show_header
    echo -e "${YELLOW}Data Processing Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} jq - JSON processing (15 exercises)"
    echo -e "${GREEN}2.${NC} column - Format tables (10 exercises)"
    echo -e "${GREEN}3.${NC} paste - Merge lines (10 exercises)"
    echo -e "${GREEN}4.${NC} comm - Compare sorted files (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/jq-practice.sh ;;
        2) ./commands/column-practice.sh ;;
        3) ./commands/paste-practice.sh ;;
        4) ./commands/comm-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_data_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_data_menu
}

show_archive_menu() {
    show_header
    echo -e "${YELLOW}Archive Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} tar - Create/extract tarballs (12 exercises)"
    echo -e "${GREEN}2.${NC} gzip - Compress files (10 exercises)"
    echo -e "${GREEN}3.${NC} zip - Create/extract zips (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/tar-practice.sh ;;
        2) ./commands/gzip-practice.sh ;;
        3) ./commands/zip-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_archive_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_archive_menu
}

show_network_menu() {
    show_header
    echo -e "${YELLOW}Network Commands:${NC}"
    echo -e "${MAGENTA}(Note: Conceptual exercises using local data)${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} curl - HTTP requests (10 exercises)"
    echo -e "${GREEN}2.${NC} wget - Download files (10 exercises)"
    echo -e "${GREEN}3.${NC} ping - Network connectivity (8 exercises)"
    echo -e "${GREEN}4.${NC} netstat - Network statistics (8 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/curl-practice.sh ;;
        2) ./commands/wget-practice.sh ;;
        3) ./commands/ping-practice.sh ;;
        4) ./commands/netstat-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_network_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_network_menu
}

show_system_menu() {
    show_header
    echo -e "${YELLOW}System Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} ps - Process list (10 exercises)"
    echo -e "${GREEN}2.${NC} top - Process monitoring (8 exercises)"
    echo -e "${GREEN}3.${NC} df/du - Disk usage (12 exercises)"
    echo -e "${GREEN}4.${NC} env - Environment variables (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/ps-practice.sh ;;
        2) ./commands/top-practice.sh ;;
        3) ./commands/df-du-practice.sh ;;
        4) ./commands/env-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_system_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_system_menu
}

show_utils_menu() {
    show_header
    echo -e "${YELLOW}Utility Commands:${NC}"
    echo ""
    echo -e "${GREEN}1.${NC} echo - Print text (10 exercises)"
    echo -e "${GREEN}2.${NC} date - Date/time (12 exercises)"
    echo -e "${GREEN}3.${NC} xargs - Build arguments (12 exercises)"
    echo -e "${GREEN}4.${NC} alias - Command shortcuts (10 exercises)"
    echo -e "${GREEN}5.${NC} history - Command history (10 exercises)"
    echo -e "${CYAN}b.${NC} Back"
    echo ""
    read -p "Choose command: " cmd

    case "$cmd" in
        1) ./commands/echo-practice.sh ;;
        2) ./commands/date-practice.sh ;;
        3) ./commands/xargs-practice.sh ;;
        4) ./commands/alias-practice.sh ;;
        5) ./commands/history-practice.sh ;;
        b|B) show_main_menu ;;
        *) echo -e "${RED}Invalid${NC}"; sleep 1; show_utils_menu ;;
    esac
    read -p "Press Enter to continue..."
    show_utils_menu
}

show_about() {
    show_header
    echo -e "${CYAN}About the Practice System${NC}"
    echo ""
    echo "This interactive practice system helps you learn shell commands"
    echo "through hands-on exercises with automatic validation."
    echo ""
    echo -e "${YELLOW}Features:${NC}"
    echo "  • 34 commands covered"
    echo "  • 400+ interactive exercises"
    echo "  • Automatic answer validation"
    echo "  • Immediate feedback"
    echo "  • Progress tracking"
    echo "  • 3 attempts per question"
    echo "  • Hints and solutions"
    echo ""
    echo -e "${YELLOW}How to Use:${NC}"
    echo "  1. Choose a category and command"
    echo "  2. Read each question carefully"
    echo "  3. Type your command answer"
    echo "  4. Get immediate feedback"
    echo "  5. Learn from mistakes"
    echo ""
    echo -e "${YELLOW}Special Commands While Practicing:${NC}"
    echo "  • Type 'skip' to skip a question"
    echo "  • Type 'solution' to see the answer"
    echo "  • Press Ctrl+C to exit"
    echo ""
    echo -e "${YELLOW}Total Exercises:${NC} ~400 across all commands"
    echo -e "${YELLOW}Learning Time:${NC} 15-20 hours for complete mastery"
    echo ""
}

# Main execution
if [ $# -eq 0 ]; then
    show_main_menu
else
    # Direct command access
    if [ -f "./commands/$1-practice.sh" ]; then
        ./commands/$1-practice.sh
    else
        echo "Command not found: $1"
        echo "Available commands: grep, awk, sed, jq, cut, sort, etc."
    fi
fi
