#!/usr/bin/env bash

# ============================================
# Practice Engine - Core Validation System
# ============================================
# Reusable validation engine for all practice exercises
# Last Updated: December 2025

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# Global variables
export PRACTICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DATA_DIR="$PRACTICE_DIR/data"
export CURRENT_SCORE=0
export TOTAL_QUESTIONS=0
export ATTEMPTS=0
export MAX_ATTEMPTS=3

# ============================================
# Core Functions
# ============================================

# Initialize practice session
init_practice() {
    local command_name="$1"
    local total_exercises="$2"

    CURRENT_SCORE=0
    TOTAL_QUESTIONS=$total_exercises
    ATTEMPTS=0

    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║  ${CYAN}${command_name}${BLUE} Practice - Interactive Exercises          ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Total Exercises:${NC} $total_exercises"
    echo -e "${YELLOW}Instructions:${NC} Type your command and press Enter"
    echo -e "${YELLOW}Scoring:${NC} Each correct answer = 1 point"
    echo ""
    read -p "Press Enter to begin..."
    echo ""
}

# Ask a question and get user's command
ask_question() {
    local question_num="$1"
    local question_text="$2"
    local data_file="$3"
    local expected_description="$4"

    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Question $question_num of $TOTAL_QUESTIONS${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Task:${NC} $question_text"

    if [ -n "$data_file" ]; then
        echo -e "${YELLOW}Data file:${NC} $data_file"
    fi

    if [ -n "$expected_description" ]; then
        echo -e "${YELLOW}Expected:${NC} $expected_description"
    fi

    echo ""
    read -p "Your command: " user_command
    echo ""

    echo "$user_command"
}

# Execute user's command safely
execute_command() {
    local cmd="$1"
    local timeout_sec="${2:-30}"
    local working_dir="${3:-$PRACTICE_DIR}"

    # Execute with timeout, capture output and exit code
    cd "$working_dir" || return 1

    # Use timeout command if available
    if command -v timeout &> /dev/null; then
        timeout "$timeout_sec" bash -c "$cmd" 2>&1
    elif command -v gtimeout &> /dev/null; then
        # macOS with coreutils
        gtimeout "$timeout_sec" bash -c "$cmd" 2>&1
    else
        # No timeout available, run directly
        bash -c "$cmd" 2>&1
    fi

    return $?
}

# Validate output with multiple strategies
validate_output() {
    local actual="$1"
    local expected="$2"
    local mode="${3:-exact}"

    case "$mode" in
        exact)
            # Exact string match
            [ "$actual" = "$expected" ]
            ;;

        numeric)
            # Numeric comparison (handles whitespace)
            local actual_num=$(echo "$actual" | tr -d ' \t\n')
            local expected_num=$(echo "$expected" | tr -d ' \t\n')
            [ "$actual_num" = "$expected_num" ]
            ;;

        contains)
            # Check if actual contains expected
            echo "$actual" | grep -qF "$expected"
            ;;

        regex)
            # Regex pattern match
            echo "$actual" | grep -qE "$expected"
            ;;

        lines)
            # Compare line count
            local actual_lines=$(echo "$actual" | wc -l | tr -d ' ')
            local expected_lines=$(echo "$expected" | tr -d ' ')
            [ "$actual_lines" = "$expected_lines" ]
            ;;

        sorted)
            # Compare sorted output
            local actual_sorted=$(echo "$actual" | sort)
            local expected_sorted=$(echo "$expected" | sort)
            [ "$actual_sorted" = "$expected_sorted" ]
            ;;

        *)
            echo "Unknown validation mode: $mode" >&2
            return 2
            ;;
    esac
}

# Show feedback after validation
show_feedback() {
    local is_correct="$1"
    local actual="$2"
    local expected="$3"
    local hint="$4"

    if [ "$is_correct" = "true" ]; then
        echo -e "${GREEN}✓ Correct!${NC}"
        ((CURRENT_SCORE++))
        echo -e "${GREEN}Score: $CURRENT_SCORE / $TOTAL_QUESTIONS${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}✗ Incorrect${NC}"
        echo ""

        # Show actual vs expected
        echo -e "${YELLOW}Your output:${NC}"
        echo "$actual"
        echo ""
        echo -e "${YELLOW}Expected output:${NC}"
        echo "$expected"
        echo ""

        # Show hint if available
        if [ -n "$hint" ]; then
            echo -e "${CYAN}Hint:${NC} $hint"
            echo ""
        fi

        return 1
    fi
}

# Ask if user wants to retry
offer_retry() {
    local attempts="$1"
    local max_attempts="$2"

    if [ "$attempts" -ge "$max_attempts" ]; then
        echo -e "${RED}Maximum attempts reached ($max_attempts)${NC}"
        echo -e "${YELLOW}Moving to next question...${NC}"
        echo ""
        return 1
    fi

    read -p "Try again? (y/n): " retry
    echo ""

    if [[ "$retry" =~ ^[Yy] ]]; then
        return 0
    else
        echo -e "${YELLOW}Moving to next question...${NC}"
        echo ""
        return 1
    fi
}

# Show solution after max attempts
show_solution() {
    local solution="$1"
    local explanation="$2"

    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}Solution:${NC}"
    echo ""
    echo -e "${GREEN}$solution${NC}"
    echo ""

    if [ -n "$explanation" ]; then
        echo -e "${YELLOW}Explanation:${NC}"
        echo "$explanation"
        echo ""
    fi

    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo ""
    read -p "Press Enter to continue..."
    echo ""
}

# Run a single exercise with validation and retry logic
run_exercise() {
    local question_num="$1"
    local question_text="$2"
    local data_file="$3"
    local expected_output="$4"
    local expected_description="$5"
    local validation_mode="${6:-exact}"
    local hint="$7"
    local solution="$8"
    local explanation="$9"

    local attempts=0
    local max_attempts=3
    local correct=false

    while [ "$attempts" -lt "$max_attempts" ] && [ "$correct" = "false" ]; do
        # Ask the question
        user_cmd=$(ask_question "$question_num" "$question_text" "$data_file" "$expected_description")

        # Check if user wants to skip
        if [ "$user_cmd" = "skip" ] || [ "$user_cmd" = "s" ]; then
            echo -e "${YELLOW}Skipping question...${NC}"
            echo ""
            break
        fi

        # Check if user wants solution
        if [ "$user_cmd" = "solution" ] || [ "$user_cmd" = "sol" ]; then
            show_solution "$solution" "$explanation"
            break
        fi

        # Execute the command
        actual_output=$(execute_command "$user_cmd")
        exit_code=$?

        # Handle execution errors
        if [ $exit_code -ne 0 ] && [ $exit_code -ne 1 ]; then
            echo -e "${RED}Error executing command (exit code: $exit_code)${NC}"
            echo ""
            ((attempts++))

            if ! offer_retry "$attempts" "$max_attempts"; then
                break
            fi
            continue
        fi

        # Validate output
        if validate_output "$actual_output" "$expected_output" "$validation_mode"; then
            show_feedback true "$actual_output" "$expected_output" "$hint"
            correct=true
        else
            ((attempts++))
            show_feedback false "$actual_output" "$expected_output" "$hint"

            if [ "$attempts" -lt "$max_attempts" ]; then
                if ! offer_retry "$attempts" "$max_attempts"; then
                    break
                fi
            else
                echo -e "${RED}Maximum attempts reached.${NC}"
                echo ""
                show_solution "$solution" "$explanation"
            fi
        fi
    done
}

# Show final score and summary
show_final_score() {
    local command_name="$1"
    local percentage=$((CURRENT_SCORE * 100 / TOTAL_QUESTIONS))

    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║              ${CYAN}Practice Complete!${BLUE}                      ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Command:${NC} $command_name"
    echo -e "${YELLOW}Score:${NC} $CURRENT_SCORE / $TOTAL_QUESTIONS ($percentage%)"
    echo ""

    # Performance assessment
    if [ "$percentage" -ge 90 ]; then
        echo -e "${GREEN}⭐⭐⭐ Excellent! Master level!${NC}"
    elif [ "$percentage" -ge 75 ]; then
        echo -e "${GREEN}⭐⭐ Great job! Very good understanding!${NC}"
    elif [ "$percentage" -ge 60 ]; then
        echo -e "${YELLOW}⭐ Good effort! Keep practicing!${NC}"
    else
        echo -e "${RED}Keep learning! Review the demos and try again.${NC}"
    fi

    echo ""

    # Save progress
    save_progress "$command_name" "$CURRENT_SCORE" "$TOTAL_QUESTIONS"
}

# Save progress to file
save_progress() {
    local command_name="$1"
    local score="$2"
    local total="$3"
    local user=$(whoami)
    local progress_file="$PRACTICE_DIR/practice/.progress/${user}.json"
    local timestamp=$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')

    mkdir -p "$PRACTICE_DIR/practice/.progress"

    # Create or update progress file
    if [ ! -f "$progress_file" ]; then
        cat > "$progress_file" << EOF
{
  "user": "$user",
  "started": "$timestamp",
  "commands": {}
}
EOF
    fi

    # Update with jq if available, otherwise append
    if command -v jq &> /dev/null; then
        local temp_file=$(mktemp)
        jq --arg cmd "$command_name" --arg score "$score" --arg total "$total" --arg time "$timestamp" \
            '.commands[$cmd] = {
                "score": ($score | tonumber),
                "total": ($total | tonumber),
                "percentage": (($score | tonumber) * 100 / ($total | tonumber)),
                "last_attempt": $time
            }' "$progress_file" > "$temp_file"
        mv "$temp_file" "$progress_file"
    fi
}

# Show user's overall progress
show_progress() {
    local user=$(whoami)
    local progress_file="$PRACTICE_DIR/practice/.progress/${user}.json"

    if [ ! -f "$progress_file" ]; then
        echo -e "${YELLOW}No progress recorded yet.${NC}"
        echo ""
        return
    fi

    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}║              ${CYAN}Your Progress${BLUE}                           ║${NC}"
    echo -e "${BLUE}║                                                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if command -v jq &> /dev/null; then
        jq -r '.commands | to_entries | .[] | "\(.key): \(.value.score)/\(.value.total) (\(.value.percentage)%)"' "$progress_file"
    else
        cat "$progress_file"
    fi

    echo ""
}

# Export functions for use in practice files
export -f init_practice
export -f ask_question
export -f execute_command
export -f validate_output
export -f show_feedback
export -f offer_retry
export -f show_solution
export -f run_exercise
export -f show_final_score
export -f save_progress
export -f show_progress
