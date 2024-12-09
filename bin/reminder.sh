#!/usr/bin/env bash

source "$(dirname ${0})/lib/logger.sh"
LOG_FILE="/tmp/prayer_reminder_log"
set_log_file "$LOG_FILE"

set_log_level "silent" # "silent", "error", "warn", "info", or "debug". "info" is the default
#set_log_level "info" # "silent", "error", "warn", "info", or "debug". "info" is the default
#set_log_level "debug" # "silent", "error", "warn", "info", or "debug". "info" is the default
log_debug "LOG_FILE: ${LOG_FILE}"
log_debug "LOG_LEVEL: ${LOG_LEVEL}"

# Source the library
source "$(dirname ${0})/lib/maybe.sh"
source "$(dirname ${0})/lib/helpers.sh"

PRAYER_TIMES_FILE="/tmp/${USER}-prayer_times_file"
#PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_TIMES_FIFO="/tmp/prayer_times_fifo"
PRAYER_REMINDER_FIFO="/tmp/prayer_reminder_fifo"
FIFO_INPUT="$PRAYER_TIMES_FIFO"
FIFO_OUTPUT="$PRAYER_REMINDER_FIFO"
#SOCKET="/tmp/prayer_times_socket"

# Ensure the reminder FIFO exists
[ ! -p "$PRAYER_TIMES_FILE" ] && touch "$PRAYER_TIMES_FILE"
# [ ! -p "$PRAYER_REMINDER_FILE" ] && touch "$PRAYER_REMINDER_FILE"
[ ! -p "$PRAYER_TIMES_FIFO" ] && mkfifo "$PRAYER_TIMES_FIFO"
[ ! -p "$PRAYER_REMINDER_FIFO" ] && mkfifo "$PRAYER_REMINDER_FIFO"

# ANSI color codes
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"

# - input file
# - output file
# - log file
#main_loop_impure() {
impure_main_loop() {
    local line="$1"
    local fifo="$2"
    local debug_log="$3"
    local toggle=0  # Initial toggle state
    local current_time
    local processed_line

    while true; do
      current_time=$(date +"%H:%M")

      # Process the prayer times using the current toggle state
      #processed_line=$(pure_process_prayer_entry "$line" "$current_time" "$toggle")
      #
      # Write the processed line to FIFO and log
      #echo "$processed_line" | tee -a "$debug_log" > "$fifo"
      #
      pure_process_prayer_entry "$line" "$current_time" "$toggle" > "$fifo"

      # Alternate the toggle state (alternate between 0 and 1)
      toggle=$((1 - $toggle))

      # Wait for 1 second before next loop iteration
      sleep 1
    done
}

impure_main_loop "$(impure_string_from_file "${PRAYER_TIMES_FILE}")" "$PRAYER_REMINDER_FIFO" "$LOG_FILE"
