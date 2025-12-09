# Scenario: Deployment Failure Investigation

**Difficulty:** Intermediate
**Time:** 15-20 minutes
**Skills:** grep, awk, sed, pipes

---

## 🎯 Challenge

Your Salesforce deployment to production failed. The deployment log is available, but it's long and complex. Your task is to quickly identify:

1. Which components failed to deploy
2. Why the deployment failed
3. Which tests failed
4. What the code coverage was
5. Recommended next steps

---

## 📋 Background

- **Deploy ID:** 0Af5e000009vRq9CAE
- **Target Org:** production@acme.com
- **Log File:** `../../data/logs/deployment.log`
- **Status:** Failed ❌

---

## 🔍 Your Tasks

### Task 1: Quick Summary

Extract the deployment summary information:

- How long did it take?
- How many components succeeded vs failed?
- What was the final status?

**Hint:** Look for "Deployment Summary" section

### Task 2: Find Failed Components

List all components that failed to deploy with their error messages.

**Hint:** Use grep to find "ComponentStatus: Failed" and the lines around it

### Task 3: Test Failures

Identify which test(s) failed and why.

**Hint:** Look for "Status: Fail" in the test execution section

### Task 4: Code Coverage Analysis

What was the overall code coverage? Which classes have low coverage?

**Hint:** Look for "Code Coverage:" section

### Task 5: Root Cause

Based on your findings, what are the TWO main issues preventing deployment?

---

## 💡 Solution Approach

### Step 1: Get Overview

```bash
cd ../../data/logs
tail -20 deployment.log
```

This shows the summary at the end of the log.

### Step 2: Find Failed Components

```bash
grep -A 1 "ComponentStatus: Failed" deployment.log
```

**Expected Output:**

- OpportunityTrigger - Compilation error at line 45
- Account.CustomRevenue\_\_c - Field already exists

### Step 3: Find Failed Tests

```bash
grep -A 2 "Status: Fail" deployment.log
```

**Expected Output:**

- OpportunityServiceTest.testCloseDeals
- Assertion Failed: Expected: 5, Actual: 4 at line 42

### Step 4: Extract Coverage

```bash
grep -A 5 "Code Coverage:" deployment.log
```

**Expected Output:**

- Overall Coverage: 85%
- OpportunityService: 72% (below recommended 75%)

### Step 5: Create Action Plan

```bash
grep "Recommendations:" -A 10 deployment.log
```

---

## ✅ Solutions

### Task 1 Answer

```bash
grep -A 3 "Deployment Status:" deployment.log
```

**Result:**

- Duration: 63 seconds
- Components Succeeded: 13
- Components Failed: 2
- Status: Failed

### Task 2 Answer

```bash
grep -B 2 -A 2 "ComponentStatus: Failed" deployment.log
```

**Failed Components:**

1. \*\*Opp

ortunityTrigger** - Unexpected token 'if' at line 45, column 8 2. **Account.CustomRevenue\_\_c\*\* - Field already exists

### Task 3 Answer

```bash
grep -B 1 -A 3 "Status: Fail" deployment.log
```

**Failed Test:**

- **OpportunityServiceTest.testCloseDeals**
- Error: System.AssertException: Assertion Failed: Expected: 5, Actual: 4
- Location: line 42

### Task 4 Answer

```bash
awk '/Code Coverage:/,/Overall Coverage:/' deployment.log
```

**Coverage Results:**

- AccountTriggerHandler: 95%
- OpportunityService: 72% (⚠️ below threshold)
- ContactHelper: 88%
- LeadConverter: 91%
- **Overall: 85%**

### Task 5 Answer

**Root Causes:**

1. **Syntax Error:** OpportunityTrigger has a compilation error at line 45
2. **Metadata Conflict:** CustomRevenue\_\_c field already exists in target org

**Secondary Issue:** 3. **Test Failure:** OpportunityServiceTest expects 5 opportunities but gets 4

---

## 🎓 What You Learned

- Using grep with context lines (-A, -B, -C)
- Extracting specific sections from logs
- Combining grep with other tools
- Reading deployment logs efficiently
- Identifying root causes quickly

---

## 🚀 Next Steps

To fix this deployment:

1. **Fix the syntax error:**

   ```bash
   # Open and fix OpportunityTrigger.trigger at line 45
   ```

2. **Handle the field conflict:**

   - Either remove CustomRevenue\_\_c from package.xml
   - Or update the existing field instead of creating new

3. **Fix the test:**

   - Review OpportunityServiceTest.testCloseDeals
   - Fix assertion or test data at line 42

4. **Retry deployment:**
   ```bash
   sf project deploy start --deploy-id 0Af5e000009vRq9CAE
   ```

---

## 🏆 Bonus Challenges

1. Extract all line numbers mentioned in errors
2. Create a one-liner that lists all failed components
3. Calculate the percentage of failed components
4. Find all WARNING messages in the log

### Bonus Solutions

```bash
# 1. Extract line numbers
grep -oE "line [0-9]+" deployment.log

# 2. One-liner for failed components
grep "ComponentStatus: Failed" -B 1 deployment.log | grep "Processing" | awk '{print $3}'

# 3. Calculate failure percentage
echo "scale=2; 2/15*100" | bc
# Result: 13.33%

# 4. Find warnings (if any exist in your actual logs)
grep -i "warning" deployment.log
```

---

**Great job! You've successfully debugged a failed deployment using shell commands.** 🎉
