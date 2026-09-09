#!/usr/bin/env bash
# Build this project against every configured ESP-IDF version and report results.
set -u

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# Ordered list of versions to build, oldest to newest (bash associative
# arrays do not preserve insertion order, so a plain array drives the loop).
IDF_VERSION_NAMES=(v5.5.4 v6.0.1 v6.0.2 v6.1 master)

declare -A IDF_VERSIONS=(
  [v5.5.4]="$HOME/.espressif/v5.5.4/esp-idf/export.sh"
  [v6.0.1]="$HOME/.espressif/v6.0.1/esp-idf/export.sh"
  [v6.0.2]="$HOME/.espressif/v6.0.2/esp-idf/export.sh"
  [v6.1]="$HOME/Development/esp-idf/export.sh"
  [master]="$HOME/.espressif/master/esp-idf/export.sh"
)

# master tracks a moving branch; update it separately with
# ./update_master_idf.sh before running this script (it's slow: fetch +
# submodule update). This script does not update it automatically.

echo "==> Cleaning old build directories and dependencies.lock"
rm -rf "$PROJECT_DIR"/build_*
rm -rf "$PROJECT_DIR"/build
rm -f "$PROJECT_DIR"/dependencies.lock

mkdir -p "$PROJECT_DIR/logs"

echo "==> Updating components"
for comp_dir in "$PROJECT_DIR"/components/*/; do
  comp_name="$(basename "$comp_dir")"
  if [ -d "$comp_dir/.git" ]; then
    echo "==> [$comp_name] git pull"
    (cd "$comp_dir" && git pull) >> "$PROJECT_DIR/logs/components_update.log" 2>&1
    if [ $? -ne 0 ]; then
      echo "WARNING: git pull failed for component $comp_name, see logs/components_update.log"
    fi
  fi
done

declare -A RESULTS

for name in "${IDF_VERSION_NAMES[@]}"; do
  export_script="${IDF_VERSIONS[$name]}"
  log_file="$PROJECT_DIR/logs/build_${name}.log"
  build_dir="build_${name}"

  echo "==> [$name] building (log: $log_file)"

  if [ ! -f "$export_script" ]; then
    echo "SKIPPED (export.sh not found: $export_script)" | tee "$log_file"
    RESULTS[$name]="SKIPPED"
    continue
  fi

  expected_idf_path="$(cd "$(dirname "$export_script")" && pwd)"

  (
    # Start from a clean slate so a pre-existing IDF environment in the
    # interactive shell (e.g. sourced in .bashrc) can't leak in and silently
    # build against the wrong toolchain if this export.sh fails.
    unset IDF_PATH IDF_PYTHON_ENV_PATH IDF_TOOLS_EXPORT_CMD IDF_TOOLS_INSTALL_CMD
    PATH="/usr/bin:/bin"

    if ! source "$export_script" > /tmp/export_output.$$ 2>&1; then
      echo "export.sh FAILED:"
      cat /tmp/export_output.$$
      rm -f /tmp/export_output.$$
      exit 99
    fi
    rm -f /tmp/export_output.$$

    if [ "${IDF_PATH:-}" != "$expected_idf_path" ]; then
      echo "REFUSING TO BUILD: expected IDF_PATH=$expected_idf_path but got IDF_PATH=${IDF_PATH:-<unset>}"
      exit 98
    fi

    idf.py -B "$build_dir" build
  ) > "$log_file" 2>&1

  status=$?
  if [ $status -eq 0 ]; then
    RESULTS[$name]="OK"
  else
    RESULTS[$name]="FAILED (exit $status)"
  fi
  echo "==> [$name] done: ${RESULTS[$name]}"
done

echo
echo "===================== SUMMARY ====================="
for name in "${IDF_VERSION_NAMES[@]}"; do
  printf "%-10s %s\n" "$name" "${RESULTS[$name]}"
done
echo "====================================================="
echo "Full logs are in $PROJECT_DIR/logs/"
