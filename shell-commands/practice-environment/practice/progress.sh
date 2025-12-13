#!/usr/bin/env bash

# ============================================
# Progress Tracking and Reporting
# ============================================
# View and manage your practice progress
# Last Updated: December 2025

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRACTICE_DIR="$(dirname "$SCRIPT_DIR")"
PROGRESS_DIR="$SCRIPT_DIR/.progress"
USER=$(whoami)
PROGRESS_FILE="$PROGRESS_DIR/${USER}.json"

# Initialize progress file if it doesn't exist
init_progress_file() {
    mkdir -p "$PROGRESS_DIR"

    if [ ! -f "$PROGRESS_FILE" ]; then
        cat > "$PROGRESS_FILE" << EOF
{
  "user": "$USER",
  "started": "$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')",
  "commands": {}
}
EOF
        echo -e "${GREEN}Progress tracking initialized for $USER${NC}"
    fi
}

# Show detailed progress report
show_detailed_progress() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo -e "${YELLOW}No progress recorded yet.${NC}"
        echo -e "${CYAN}Start practicing to track your progress!${NC}"
        echo ""
        return
    fi

    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                ║${NC}"
    echo -e "${BLUE}║              ${CYAN}Shell Commands Practice Progress${BLUE}                 ║${NC}"
    echo -e "${BLUE}║                                                                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Note: Install 'jq' for better formatting${NC}"
        echo ""
        cat "$PROGRESS_FILE"
        return
    fi

    # Extract data with jq
    local started=$(jq -r '.started' "$PROGRESS_FILE")
    local commands_count=$(jq '.commands | length' "$PROGRESS_FILE")

    echo -e "${YELLOW}User:${NC} $USER"
    echo -e "${YELLOW}Started:${NC} $started"
    echo -e "${YELLOW}Commands Practiced:${NC} $commands_count"
    echo ""

    if [ "$commands_count" -eq 0 ]; then
        echo -e "${CYAN}No exercises completed yet. Start practicing!${NC}"
        echo ""
        return
    fi

    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Command              Score    Percentage    Last Attempt${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    jq -r '.commands | to_entries | .[] |
        "\(.key)|\(.value.score)|\(.value.total)|\(.value.percentage)|\(.value.last_attempt)"' \
        "$PROGRESS_FILE" | while IFS='|' read -r cmd score total pct last_attempt; do

        # Color code based on percentage
        if [ "$pct" -ge 90 ]; then
            color=$GREEN
        elif [ "$pct" -ge 75 ]; then
            color=$CYAN
        elif [ "$pct" -ge 60 ]; then
            color=$YELLOW
        else
            color=$RED
        fi

        printf "${color}%-18s${NC}   %2d/%-2d    %3d%%         %s\n" \
            "$cmd" "$score" "$total" "$pct" "${last_attempt:0:10}"
    done

    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # Calculate overall statistics
    local total_score=$(jq '[.commands[].score] | add // 0' "$PROGRESS_FILE")
    local total_possible=$(jq '[.commands[].total] | add // 0' "$PROGRESS_FILE")
    local overall_pct=0

    if [ "$total_possible" -gt 0 ]; then
        overall_pct=$((total_score * 100 / total_possible))
    fi

    echo -e "${YELLOW}Overall:${NC} $total_score / $total_possible ($overall_pct%)"
    echo ""

    # Show mastery level
    if [ "$overall_pct" -ge 90 ]; then
        echo -e "${GREEN}⭐⭐⭐ Master Level! Excellent work!${NC}"
    elif [ "$overall_pct" -ge 75 ]; then
        echo -e "${GREEN}⭐⭐ Advanced Level! Great job!${NC}"
    elif [ "$overall_pct" -ge 60 ]; then
        echo -e "${YELLOW}⭐ Intermediate Level! Keep practicing!${NC}"
    elif [ "$overall_pct" -gt 0 ]; then
        echo -e "${CYAN}Beginner Level! You're making progress!${NC}"
    fi

    echo ""
}

# Show summary (compact format)
show_summary() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo -e "${YELLOW}No progress recorded yet.${NC}"
        return
    fi

    if ! command -v jq &> /dev/null; then
        cat "$PROGRESS_FILE"
        return
    fi

    local commands_count=$(jq '.commands | length' "$PROGRESS_FILE")
    local total_score=$(jq '[.commands[].score] | add // 0' "$PROGRESS_FILE")
    local total_possible=$(jq '[.commands[].total] | add // 0' "$PROGRESS_FILE")
    local overall_pct=0

    if [ "$total_possible" -gt 0 ]; then
        overall_pct=$((total_score * 100 / total_possible))
    fi

    echo -e "${CYAN}Progress:${NC} $commands_count commands | $total_score/$total_possible ($overall_pct%)"
}

# Show commands that need practice (< 75%)
show_needs_practice() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo -e "${YELLOW}No progress recorded yet.${NC}"
        return
    fi

    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Install 'jq' to use this feature${NC}"
        return
    fi

    echo -e "${YELLOW}Commands needing more practice (< 75%):${NC}"
    echo ""

    local found=false
    jq -r '.commands | to_entries | .[] | select(.value.percentage < 75) |
        "\(.key)|\(.value.percentage)"' "$PROGRESS_FILE" | while IFS='|' read -r cmd pct; do
        echo -e "  ${RED}•${NC} $cmd (${pct}%)"
        found=true
    done

    if [ "$found" = "false" ]; then
        echo -e "${GREEN}All practiced commands are at 75% or higher!${NC}"
    fi

    echo ""
}

# Show mastered commands (>= 90%)
show_mastered() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo -e "${YELLOW}No progress recorded yet.${NC}"
        return
    fi

    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Install 'jq' to use this feature${NC}"
        return
    fi

    echo -e "${GREEN}Mastered commands (≥ 90%):${NC}"
    echo ""

    local found=false
    jq -r '.commands | to_entries | .[] | select(.value.percentage >= 90) |
        "\(.key)|\(.value.percentage)"' "$PROGRESS_FILE" | while IFS='|' read -r cmd pct; do
        echo -e "  ${GREEN}⭐${NC} $cmd (${pct}%)"
        found=true
    done

    if [ "$found" = "false" ]; then
        echo -e "${CYAN}No commands mastered yet. Keep practicing!${NC}"
    fi

    echo ""
}

# Reset progress (with confirmation)
reset_progress() {
    echo -e "${RED}WARNING: This will delete all your progress!${NC}"
    read -p "Are you sure? (yes/no): " confirm

    if [ "$confirm" = "yes" ]; then
        rm -f "$PROGRESS_FILE"
        echo -e "${GREEN}Progress reset complete.${NC}"
        init_progress_file
    else
        echo -e "${CYAN}Reset cancelled.${NC}"
    fi
}

# Export progress to CSV
export_progress() {
    if [ ! -f "$PROGRESS_FILE" ]; then
        echo -e "${YELLOW}No progress to export.${NC}"
        return
    fi

    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required for export${NC}"
        return
    fi

    local export_file="progress_${USER}_$(date +%Y%m%d).csv"

    echo "Command,Score,Total,Percentage,Last Attempt" > "$export_file"
    jq -r '.commands | to_entries | .[] |
        "\(.key),\(.value.score),\(.value.total),\(.value.percentage),\(.value.last_attempt)"' \
        "$PROGRESS_FILE" >> "$export_file"

    echo -e "${GREEN}Progress exported to:${NC} $export_file"
}

# Main menu
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║        ${CYAN}Progress Tracking${BLUE}                             ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}1.${NC} View detailed progress"
    echo -e "${YELLOW}2.${NC} Show summary"
    echo -e "${YELLOW}3.${NC} Commands needing practice"
    echo -e "${YELLOW}4.${NC} Mastered commands"
    echo -e "${YELLOW}5.${NC} Export to CSV"
    echo -e "${YELLOW}6.${NC} Reset progress"
    echo -e "${YELLOW}q.${NC} Quit"
    echo ""
    read -p "Choose an option: " choice
    echo ""

    case "$choice" in
        1) show_detailed_progress ;;
        2) show_summary ;;
        3) show_needs_practice ;;
        4) show_mastered ;;
        5) export_progress ;;
        6) reset_progress ;;
        q|Q) exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ;;
    esac
}

# Main execution
init_progress_file

if [ $# -eq 0 ]; then
    # Interactive mode
    while true; do
        show_menu
        echo ""
        read -p "Press Enter to continue..."
        clear
    done
else
    # Command line mode
    case "$1" in
        show|view) show_detailed_progress ;;
        summary) show_summary ;;
        needs) show_needs_practice ;;
        mastered) show_mastered ;;
        export) export_progress ;;
        reset) reset_progress ;;
        *)
            echo "Usage: $0 [show|summary|needs|mastered|export|reset]"
            echo "  Or run without arguments for interactive menu"
            ;;
    esac
fi
