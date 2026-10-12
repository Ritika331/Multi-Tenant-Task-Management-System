#!/bin/bash

# Multi-Tenant Test Script
# Tests the multi-tenant isolation with 2 organizations

BASE_URL="http://localhost:8080"
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Multi-Tenant Test Script ===${NC}\n"

# Step 1: Create Organizations
echo -e "${BLUE}Step 1: Creating Organizations${NC}"
ORG1_RESPONSE=$(curl -s -X POST $BASE_URL/organizations \
  -H "Content-Type: application/json" \
  -d '{"name": "TechCorp", "email": "contact@techcorp.com"}')
ORG1_ID=$(echo $ORG1_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created Organization 1 (ID: $ORG1_ID)${NC}"

ORG2_RESPONSE=$(curl -s -X POST $BASE_URL/organizations \
  -H "Content-Type: application/json" \
  -d '{"name": "StartupXYZ", "email": "info@startupxyz.com"}')
ORG2_ID=$(echo $ORG2_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created Organization 2 (ID: $ORG2_ID)${NC}\n"

# Step 2: Create Users
echo -e "${BLUE}Step 2: Creating Users${NC}"
USER1_RESPONSE=$(curl -s -X POST $BASE_URL/users \
  -H "Content-Type: application/json" \
  -H "X-ORG-ID: $ORG1_ID" \
  -d '{"name": "Alice", "email": "alice@techcorp.com"}')
USER1_ID=$(echo $USER1_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created User for Org 1 (ID: $USER1_ID)${NC}"

USER2_RESPONSE=$(curl -s -X POST $BASE_URL/users \
  -H "Content-Type: application/json" \
  -H "X-ORG-ID: $ORG2_ID" \
  -d '{"name": "Bob", "email": "bob@startupxyz.com"}')
USER2_ID=$(echo $USER2_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created User for Org 2 (ID: $USER2_ID)${NC}\n"

# Step 3: Create Tasks
echo -e "${BLUE}Step 3: Creating Tasks${NC}"
TASK1_RESPONSE=$(curl -s -X POST $BASE_URL/tasks \
  -H "Content-Type: application/json" \
  -H "X-ORG-ID: $ORG1_ID" \
  -d "{\"title\": \"Build API\", \"description\": \"Create REST API\", \"status\": \"PENDING\", \"assignedUserId\": $USER1_ID}")
TASK1_ID=$(echo $TASK1_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created Task for Org 1 (ID: $TASK1_ID)${NC}"

TASK2_RESPONSE=$(curl -s -X POST $BASE_URL/tasks \
  -H "Content-Type: application/json" \
  -H "X-ORG-ID: $ORG2_ID" \
  -d "{\"title\": \"Design Logo\", \"description\": \"Create company logo\", \"status\": \"PENDING\", \"assignedUserId\": $USER2_ID}")
TASK2_ID=$(echo $TASK2_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2)
echo -e "${GREEN}✓ Created Task for Org 2 (ID: $TASK2_ID)${NC}\n"

# Step 4: Test Tenant Isolation
echo -e "${BLUE}Step 4: Testing Tenant Isolation${NC}"

# Test 1: Org 1 should see only their tasks
echo -e "${BLUE}Test 1: Org 1 lists tasks${NC}"
ORG1_TASKS=$(curl -s -X GET $BASE_URL/tasks -H "X-ORG-ID: $ORG1_ID")
if echo "$ORG1_TASKS" | grep -q "Build API"; then
    echo -e "${GREEN}✓ Org 1 sees their task 'Build API'${NC}"
else
    echo -e "${RED}✗ Org 1 cannot see their task${NC}"
fi
if echo "$ORG1_TASKS" | grep -q "Design Logo"; then
    echo -e "${RED}✗ Org 1 can see Org 2's task (SECURITY ISSUE!)${NC}"
else
    echo -e "${GREEN}✓ Org 1 cannot see Org 2's task${NC}"
fi

# Test 2: Org 2 should see only their tasks
echo -e "${BLUE}Test 2: Org 2 lists tasks${NC}"
ORG2_TASKS=$(curl -s -X GET $BASE_URL/tasks -H "X-ORG-ID: $ORG2_ID")
if echo "$ORG2_TASKS" | grep -q "Design Logo"; then
    echo -e "${GREEN}✓ Org 2 sees their task 'Design Logo'${NC}"
else
    echo -e "${RED}✗ Org 2 cannot see their task${NC}"
fi
if echo "$ORG2_TASKS" | grep -q "Build API"; then
    echo -e "${RED}✗ Org 2 can see Org 1's task (SECURITY ISSUE!)${NC}"
else
    echo -e "${GREEN}✓ Org 2 cannot see Org 1's task${NC}"
fi

# Test 3: Cross-tenant access prevention
echo -e "${BLUE}Test 3: Org 2 tries to access Org 1's task${NC}"
CROSS_ACCESS=$(curl -s -X GET $BASE_URL/tasks/$TASK1_ID -H "X-ORG-ID: $ORG2_ID")
if echo "$CROSS_ACCESS" | grep -q "not found"; then
    echo -e "${GREEN}✓ Cross-tenant access blocked${NC}"
else
    echo -e "${RED}✗ Cross-tenant access allowed (SECURITY ISSUE!)${NC}"
fi

# Test 4: Cross-tenant delete prevention
echo -e "${BLUE}Test 4: Org 2 tries to delete Org 1's task${NC}"
CROSS_DELETE=$(curl -s -X DELETE $BASE_URL/tasks/$TASK1_ID -H "X-ORG-ID: $ORG2_ID")
if echo "$CROSS_DELETE" | grep -q "not found"; then
    echo -e "${GREEN}✓ Cross-tenant delete blocked${NC}"
else
    echo -e "${RED}✗ Cross-tenant delete allowed (SECURITY ISSUE!)${NC}"
fi

# Test 5: Cross-tenant user assignment
echo -e "${BLUE}Test 5: Org 1 tries to assign task to Org 2's user${NC}"
CROSS_ASSIGN=$(curl -s -X POST $BASE_URL/tasks \
  -H "Content-Type: application/json" \
  -H "X-ORG-ID: $ORG1_ID" \
  -d "{\"title\": \"Test Task\", \"description\": \"Test\", \"status\": \"PENDING\", \"assignedUserId\": $USER2_ID}")
if echo "$CROSS_ASSIGN" | grep -q "does not belong"; then
    echo -e "${GREEN}✓ Cross-tenant user assignment blocked${NC}"
else
    echo -e "${RED}✗ Cross-tenant user assignment allowed (SECURITY ISSUE!)${NC}"
fi

# Test 6: List users per tenant
echo -e "${BLUE}Test 6: List users per tenant${NC}"
ORG1_USERS=$(curl -s -X GET $BASE_URL/users -H "X-ORG-ID: $ORG1_ID")
if echo "$ORG1_USERS" | grep -q "Alice"; then
    echo -e "${GREEN}✓ Org 1 sees their user Alice${NC}"
else
    echo -e "${RED}✗ Org 1 cannot see their user${NC}"
fi
if echo "$ORG1_USERS" | grep -q "Bob"; then
    echo -e "${RED}✗ Org 1 can see Org 2's user Bob (SECURITY ISSUE!)${NC}"
else
    echo -e "${GREEN}✓ Org 1 cannot see Org 2's user${NC}"
fi

echo -e "\n${BLUE}=== Test Summary ===${NC}"
echo "Organization 1 ID: $ORG1_ID"
echo "Organization 2 ID: $ORG2_ID"
echo "User 1 (Alice) ID: $USER1_ID"
echo "User 2 (Bob) ID: $USER2_ID"
echo "Task 1 (Build API) ID: $TASK1_ID"
echo "Task 2 (Design Logo) ID: $TASK2_ID"
