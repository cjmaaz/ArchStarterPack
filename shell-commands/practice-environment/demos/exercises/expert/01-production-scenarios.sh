#!/usr/bin/env bash

# ============================================
# Expert Level: Production Scenarios
# ============================================
# Real-world production debugging challenges

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../.."

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Expert Level: Production Scenarios${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${RED}These are real-world production challenges${NC}"
echo "You'll need to combine multiple commands creatively"
echo ""

# Scenario 1
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}SCENARIO 1: Production Incident Response${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
echo "🚨 INCIDENT: Users reporting slow response times"
echo ""
echo "Your task:"
echo "  1. Identify slow queries (>1s) from logs"
echo "  2. Find which users are affected"
echo "  3. Determine peak error times"
echo "  4. Generate incident report"
echo ""
read -p "Think about your approach, then press Enter for guided solution..."
echo ""

echo -e "${GREEN}Step 1: Find slow queries${NC}"
echo "Command: grep -i 'slow' data/logs/application.log"
echo ""
grep -i 'slow' data/logs/application.log
echo ""

echo -e "${GREEN}Step 2: Extract affected users${NC}"
echo "Command: grep 'ERROR' data/logs/application.log | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' | sort -u"
echo ""
grep 'ERROR' data/logs/application.log | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' | sort -u
echo ""

echo -e "${GREEN}Step 3: Error timeline (hourly breakdown)${NC}"
echo "Command: grep 'ERROR' data/logs/application.log | awk '{print \$2}' | cut -d':' -f1 | sort | uniq -c"
echo ""
grep 'ERROR' data/logs/application.log | awk '{print $2}' | cut -d':' -f1 | sort | uniq -c
echo ""

echo -e "${GREEN}Step 4: Generate incident summary${NC}"
cat << 'EOF'
{
    echo "=== INCIDENT REPORT ==="
    echo "Timestamp: $(date)"
    echo ""
    echo "Total Errors: $(grep -c 'ERROR' data/logs/application.log)"
    echo "Unique Users Affected: $(grep 'ERROR' data/logs/application.log | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' | sort -u | wc -l)"
    echo "Slow Queries: $(grep -ic 'slow' data/logs/application.log)"
    echo ""
    echo "Top 3 Error Types:"
    grep 'ERROR' data/logs/application.log | awk '{for(i=5;i<=NF;i++) printf $i" "; print ""}' | sort | uniq -c | sort -nr | head -3
} > /tmp/incident_report.txt
EOF
echo ""
echo -e "${GREEN}✓ Incident analysis complete!${NC}"
echo ""

# Scenario 2
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}SCENARIO 2: Deployment Rollback Decision${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
echo "⚠️  SITUATION: Deployment completed but tests failing"
echo ""
echo "Your task: Analyze deployment logs to decide if rollback needed"
echo "  1. Check success vs failure ratio"
echo "  2. Identify failed components"
echo "  3. Check test coverage"
echo "  4. Make recommendation"
echo ""
read -p "Press Enter for guided solution..."
echo ""

echo -e "${GREEN}Analysis 1: Success/Failure Ratio${NC}"
echo "Command: grep -E 'Component(Success|Failure)' data/logs/deployment.log | awk -F':' '{print \$1}' | sort | uniq -c"
echo ""
grep -E 'Component(Success|Failure)' data/logs/deployment.log | awk -F':' '{print $1}' | sort | uniq -c
echo ""

echo -e "${GREEN}Analysis 2: Failed Components${NC}"
echo "Command: grep 'ComponentFailure' data/logs/deployment.log"
echo ""
grep 'ComponentFailure' data/logs/deployment.log
echo ""

echo -e "${GREEN}Analysis 3: Test Results${NC}"
echo "Command: grep -i 'test' data/logs/deployment.log | head -10"
echo ""
grep -i 'test' data/logs/deployment.log | head -10
echo ""

FAILURES=$(grep -c 'ComponentFailure' data/logs/deployment.log || echo "0")
SUCCESSES=$(grep -c 'ComponentSuccess' data/logs/deployment.log || echo "0")

echo -e "${GREEN}Decision Matrix:${NC}"
echo "  Successes: $SUCCESSES"
echo "  Failures: $FAILURES"

if [ "$FAILURES" -gt 5 ]; then
    echo -e "  ${RED}RECOMMENDATION: ROLLBACK REQUIRED${NC}"
else
    echo -e "  ${GREEN}RECOMMENDATION: Monitor and fix forward${NC}"
fi
echo ""
echo -e "${GREEN}✓ Deployment analysis complete!${NC}"
echo ""

# Scenario 3
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}SCENARIO 3: Security Audit${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
echo "🔒 TASK: Security team needs access analysis"
echo ""
echo "Your task:"
echo "  1. Find all failed login attempts (status 401/403)"
echo "  2. Identify suspicious IPs (>10 failed attempts)"
echo "  3. List all accessed sensitive endpoints"
echo "  4. Generate security report"
echo ""
read -p "Press Enter for guided solution..."
echo ""

echo -e "${GREEN}Analysis 1: Failed Authentications${NC}"
echo "Command: awk '\$9 == 401 || \$9 == 403 {print \$1, \$7}' data/logs/web-access.log | head -10"
echo ""
awk '$9 == 401 || $9 == 403 {print $1, $7}' data/logs/web-access.log | head -10
echo ""

echo -e "${GREEN}Analysis 2: Suspicious IPs (Multiple Failures)${NC}"
echo "Command: awk '\$9 == 401 || \$9 == 403 {print \$1}' data/logs/web-access.log | sort | uniq -c | sort -nr | awk '\$1 > 5 {print \$2, \"(\"\$1 \" attempts)\"}'"
echo ""
awk '$9 == 401 || $9 == 403 {print $1}' data/logs/web-access.log | sort | uniq -c | sort -nr | awk '$1 > 5 {print $2, "("$1 " attempts)"}'
echo ""

echo -e "${GREEN}Analysis 3: Access Patterns by Hour${NC}"
echo "Command: awk '{print \$4}' data/logs/web-access.log | cut -d':' -f2 | sort | uniq -c"
echo ""
awk '{print $4}' data/logs/web-access.log | cut -d':' -f2 | sort | uniq -c | head -10
echo ""

echo -e "${GREEN}✓ Security audit complete!${NC}"
echo ""

# Scenario 4
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}SCENARIO 4: Data Migration Validation${NC}"
echo -e "${YELLOW}═══════════════════════════════════════${NC}"
echo ""
echo "📊 TASK: Validate data migration between systems"
echo ""
echo "Compare CSV source data with JSON API results"
echo ""
read -p "Press Enter for solution..."
echo ""

echo -e "${GREEN}Step 1: Count records in each source${NC}"
echo "CSV records: $(tail -n +2 data/csv/accounts.csv | wc -l)"
echo "JSON records: $(jq '.result.totalSize' data/json/sf-query-result.json)"
echo ""

echo -e "${GREEN}Step 2: Verify data integrity${NC}"
echo "Command: Check if all industries match"
echo ""
echo "CSV Industries:"
tail -n +2 data/csv/accounts.csv | cut -d',' -f3 | sort -u
echo ""
echo "JSON Industries:"
jq -r '.result.records[].Industry' data/json/sf-query-result.json | sort -u
echo ""

echo -e "${GREEN}Step 3: Sample data comparison${NC}"
echo "First account in CSV:"
head -2 data/csv/accounts.csv | tail -1 | cut -d',' -f2,3,4
echo ""
echo "First account in JSON:"
jq -r '.result.records[0] | "\(.Name), \(.Industry), \(.AnnualRevenue)"' data/json/sf-query-result.json
echo ""

echo -e "${GREEN}✓ Migration validation complete!${NC}"
echo ""

echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  Expert Scenarios Complete! 🏆${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "Production Skills Mastered:"
echo "  ✓ Incident response and triage"
echo "  ✓ Deployment decision making"
echo "  ✓ Security auditing"
echo "  ✓ Data migration validation"
echo "  ✓ Report generation under pressure"
echo "  ✓ Multi-source data correlation"
echo ""
echo "You're now ready for:"
echo "  • Production support"
echo "  • DevOps automation"
echo "  • Security analysis"
echo "  • Data engineering"
echo ""
echo "Continue practicing with:"
echo "  • scenarios/deployment-failure/"
echo "  • scenarios/log-investigation/"
echo ""
