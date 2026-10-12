# Multi-Tenant Test Script for Windows PowerShell
# Tests the multi-tenant isolation with 2 organizations

$BASE_URL = "http://localhost:8080"

Write-Host "=== Multi-Tenant Test Script ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Create Organizations
Write-Host "Step 1: Creating Organizations" -ForegroundColor Cyan

$org1Response = Invoke-RestMethod -Uri "$BASE_URL/organizations" -Method Post -ContentType "application/json" -Body '{"name": "TechCorp", "email": "contact@techcorp.com"}'
$ORG1_ID = $org1Response.id
Write-Host "Created Organization 1 (ID: $ORG1_ID)" -ForegroundColor Green

$org2Response = Invoke-RestMethod -Uri "$BASE_URL/organizations" -Method Post -ContentType "application/json" -Body '{"name": "StartupXYZ", "email": "info@startupxyz.com"}'
$ORG2_ID = $org2Response.id
Write-Host "Created Organization 2 (ID: $ORG2_ID)" -ForegroundColor Green
Write-Host ""

# Step 2: Create Users
Write-Host "Step 2: Creating Users" -ForegroundColor Cyan

$headers1 = @{"X-ORG-ID" = $ORG1_ID}
$user1Response = Invoke-RestMethod -Uri "$BASE_URL/users" -Method Post -ContentType "application/json" -Headers $headers1 -Body '{"name": "Alice", "email": "alice@techcorp.com"}'
$USER1_ID = $user1Response.id
Write-Host "Created User for Org 1 (ID: $USER1_ID)" -ForegroundColor Green

$headers2 = @{"X-ORG-ID" = $ORG2_ID}
$user2Response = Invoke-RestMethod -Uri "$BASE_URL/users" -Method Post -ContentType "application/json" -Headers $headers2 -Body '{"name": "Bob", "email": "bob@startupxyz.com"}'
$USER2_ID = $user2Response.id
Write-Host "Created User for Org 2 (ID: $USER2_ID)" -ForegroundColor Green
Write-Host ""

# Step 3: Create Tasks
Write-Host "Step 3: Creating Tasks" -ForegroundColor Cyan

$task1Body = @{
    title = "Build API"
    description = "Create REST API"
    status = "TODO"
    assignedUserId = $USER1_ID
} | ConvertTo-Json

$task1Response = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Post -ContentType "application/json" -Headers $headers1 -Body $task1Body
$TASK1_ID = $task1Response.id
Write-Host "Created Task for Org 1 (ID: $TASK1_ID)" -ForegroundColor Green

$task2Body = @{
    title = "Design Logo"
    description = "Create company logo"
    status = "TODO"
    assignedUserId = $USER2_ID
} | ConvertTo-Json

$task2Response = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Post -ContentType "application/json" -Headers $headers2 -Body $task2Body
$TASK2_ID = $task2Response.id
Write-Host "Created Task for Org 2 (ID: $TASK2_ID)" -ForegroundColor Green
Write-Host ""

# Step 4: Test Tenant Isolation
Write-Host "Step 4: Testing Tenant Isolation" -ForegroundColor Cyan

# Test 1: Org 1 should see only their tasks
Write-Host "Test 1: Org 1 lists tasks" -ForegroundColor Cyan
$org1Tasks = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Get -Headers $headers1
if ($org1Tasks.content.title -contains "Build API") {
    Write-Host "PASS: Org 1 sees their task 'Build API'" -ForegroundColor Green
} else {
    Write-Host "FAIL: Org 1 cannot see their task" -ForegroundColor Red
}
if ($org1Tasks.content.title -contains "Design Logo") {
    Write-Host "FAIL: Org 1 can see Org 2's task (SECURITY ISSUE)" -ForegroundColor Red
} else {
    Write-Host "PASS: Org 1 cannot see Org 2's task" -ForegroundColor Green
}

# Test 2: Org 2 should see only their tasks
Write-Host "Test 2: Org 2 lists tasks" -ForegroundColor Cyan
$org2Tasks = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Get -Headers $headers2
if ($org2Tasks.content.title -contains "Design Logo") {
    Write-Host "PASS: Org 2 sees their task 'Design Logo'" -ForegroundColor Green
} else {
    Write-Host "FAIL: Org 2 cannot see their task" -ForegroundColor Red
}
if ($org2Tasks.content.title -contains "Build API") {
    Write-Host "FAIL: Org 2 can see Org 1's task (SECURITY ISSUE)" -ForegroundColor Red
} else {
    Write-Host "PASS: Org 2 cannot see Org 1's task" -ForegroundColor Green
}

# Test 3: Cross-tenant access prevention
Write-Host "Test 3: Org 2 tries to access Org 1's task" -ForegroundColor Cyan
try {
    $crossAccess = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Get -Headers $headers2
    Write-Host "FAIL: Cross-tenant access allowed (SECURITY ISSUE)" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant access blocked" -ForegroundColor Green
}

# Test 4: Cross-tenant delete prevention
Write-Host "Test 4: Org 2 tries to delete Org 1's task" -ForegroundColor Cyan
try {
    $crossDelete = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Delete -Headers $headers2
    Write-Host "FAIL: Cross-tenant delete allowed (SECURITY ISSUE)" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant delete blocked" -ForegroundColor Green
}

# Test 5: Cross-tenant user assignment
Write-Host "Test 5: Org 1 tries to assign task to Org 2's user" -ForegroundColor Cyan
$crossAssignBody = @{
    title = "Test Task"
    description = "Test"
    status = "TODO"
    assignedUserId = $USER2_ID
} | ConvertTo-Json

try {
    $crossAssign = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Post -ContentType "application/json" -Headers $headers1 -Body $crossAssignBody
    Write-Host "FAIL: Cross-tenant user assignment allowed (SECURITY ISSUE)" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant user assignment blocked" -ForegroundColor Green
}

# Test 6: List users per tenant
Write-Host "Test 6: List users per tenant" -ForegroundColor Cyan
$org1Users = Invoke-RestMethod -Uri "$BASE_URL/users" -Method Get -Headers $headers1
if ($org1Users.name -contains "Alice") {
    Write-Host "PASS: Org 1 sees their user Alice" -ForegroundColor Green
} else {
    Write-Host "FAIL: Org 1 cannot see their user" -ForegroundColor Red
}
if ($org1Users.name -contains "Bob") {
    Write-Host "FAIL: Org 1 can see Org 2's user Bob (SECURITY ISSUE)" -ForegroundColor Red
} else {
    Write-Host "PASS: Org 1 cannot see Org 2's user" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "Organization 1 ID: $ORG1_ID"
Write-Host "Organization 2 ID: $ORG2_ID"
Write-Host "User 1 (Alice) ID: $USER1_ID"
Write-Host "User 2 (Bob) ID: $USER2_ID"
Write-Host "Task 1 (Build API) ID: $TASK1_ID"
Write-Host "Task 2 (Design Logo) ID: $TASK2_ID"
