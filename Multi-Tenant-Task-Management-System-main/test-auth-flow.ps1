# Authentication and Multi-Tenant Isolation Test Script
$BASE_URL = "http://localhost:8080"

Write-Host "=== Authentication & Multi-Tenant Isolation Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Register User 1 with Organization A
Write-Host "Test 1: Register User 1 with Organization A" -ForegroundColor Cyan
$user1Body = @{
    name = "Alice Johnson"
    email = "alice@companya.com"
    password = "password123"
    organizationName = "Company A"
} | ConvertTo-Json

$user1Response = Invoke-RestMethod -Uri "$BASE_URL/auth/register" -Method Post -ContentType "application/json" -Body $user1Body
$USER1_TOKEN = $user1Response.token
$USER1_ID = $user1Response.userId
$USER1_ORG_ID = $user1Response.organizationId
Write-Host "PASS: User 1 registered successfully" -ForegroundColor Green
Write-Host "  User ID: $USER1_ID" -ForegroundColor Gray
Write-Host "  Organization ID: $USER1_ORG_ID" -ForegroundColor Gray
Write-Host ""

# Test 2: Register User 2 with Organization B
Write-Host "Test 2: Register User 2 with Organization B" -ForegroundColor Cyan
$user2Body = @{
    name = "Bob Smith"
    email = "bob@companyb.com"
    password = "password123"
    organizationName = "Company B"
} | ConvertTo-Json

$user2Response = Invoke-RestMethod -Uri "$BASE_URL/auth/register" -Method Post -ContentType "application/json" -Body $user2Body
$USER2_TOKEN = $user2Response.token
$USER2_ID = $user2Response.userId
$USER2_ORG_ID = $user2Response.organizationId
Write-Host "PASS: User 2 registered successfully" -ForegroundColor Green
Write-Host "  User ID: $USER2_ID" -ForegroundColor Gray
Write-Host "  Organization ID: $USER2_ORG_ID" -ForegroundColor Gray
Write-Host ""

# Test 3: Verify organizations are different
Write-Host "Test 3: Verify organizations are different" -ForegroundColor Cyan
if ($USER1_ORG_ID -ne $USER2_ORG_ID) {
    Write-Host "PASS: Organizations are different" -ForegroundColor Green
} else {
    Write-Host "FAIL: Organizations are the same" -ForegroundColor Red
}
Write-Host ""

# Test 4: User 1 creates a task
Write-Host "Test 4: User 1 creates a task" -ForegroundColor Cyan
$headers1 = @{"Authorization" = "Bearer $USER1_TOKEN"}
$task1Body = @{
    title = "Company A Task"
    description = "This task belongs to Company A"
    status = "TODO"
    assignedUserId = $USER1_ID
} | ConvertTo-Json

$task1Response = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Post -ContentType "application/json" -Headers $headers1 -Body $task1Body
$TASK1_ID = $task1Response.id
Write-Host "PASS: User 1 created task (ID: $TASK1_ID)" -ForegroundColor Green
Write-Host ""

# Test 5: User 2 creates a task
Write-Host "Test 5: User 2 creates a task" -ForegroundColor Cyan
$headers2 = @{"Authorization" = "Bearer $USER2_TOKEN"}
$task2Body = @{
    title = "Company B Task"
    description = "This task belongs to Company B"
    status = "TODO"
    assignedUserId = $USER2_ID
} | ConvertTo-Json

$task2Response = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Post -ContentType "application/json" -Headers $headers2 -Body $task2Body
$TASK2_ID = $task2Response.id
Write-Host "PASS: User 2 created task (ID: $TASK2_ID)" -ForegroundColor Green
Write-Host ""

# Test 6: User 1 lists tasks
Write-Host "Test 6: User 1 lists tasks" -ForegroundColor Cyan
$user1Tasks = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Get -Headers $headers1
$user1TaskTitles = $user1Tasks.content.title
if ($user1TaskTitles -contains "Company A Task") {
    Write-Host "PASS: User 1 sees their task" -ForegroundColor Green
} else {
    Write-Host "FAIL: User 1 cannot see their task" -ForegroundColor Red
}
if ($user1TaskTitles -contains "Company B Task") {
    Write-Host "FAIL: User 1 can see User 2's task" -ForegroundColor Red
} else {
    Write-Host "PASS: User 1 cannot see User 2's task" -ForegroundColor Green
}
Write-Host ""

# Test 7: User 2 lists tasks
Write-Host "Test 7: User 2 lists tasks" -ForegroundColor Cyan
$user2Tasks = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Get -Headers $headers2
$user2TaskTitles = $user2Tasks.content.title
if ($user2TaskTitles -contains "Company B Task") {
    Write-Host "PASS: User 2 sees their task" -ForegroundColor Green
} else {
    Write-Host "FAIL: User 2 cannot see their task" -ForegroundColor Red
}
if ($user2TaskTitles -contains "Company A Task") {
    Write-Host "FAIL: User 2 can see User 1's task" -ForegroundColor Red
} else {
    Write-Host "PASS: User 2 cannot see User 1's task" -ForegroundColor Green
}
Write-Host ""

# Test 8: User 2 tries to access User 1's task
Write-Host "Test 8: User 2 tries to access User 1's task" -ForegroundColor Cyan
try {
    $crossAccess = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Get -Headers $headers2
    Write-Host "FAIL: Cross-tenant access allowed" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant access blocked" -ForegroundColor Green
}
Write-Host ""

# Test 9: User 2 tries to delete User 1's task
Write-Host "Test 9: User 2 tries to delete User 1's task" -ForegroundColor Cyan
try {
    $crossDelete = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Delete -Headers $headers2
    Write-Host "FAIL: Cross-tenant delete allowed" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant delete blocked" -ForegroundColor Green
}
Write-Host ""

# Test 10: User 1 lists users
Write-Host "Test 10: User 1 lists users" -ForegroundColor Cyan
$user1Users = Invoke-RestMethod -Uri "$BASE_URL/users" -Method Get -Headers $headers1
$user1UserNames = $user1Users.name
if ($user1UserNames -contains "Alice Johnson") {
    Write-Host "PASS: User 1 sees their user" -ForegroundColor Green
} else {
    Write-Host "FAIL: User 1 cannot see their user" -ForegroundColor Red
}
if ($user1UserNames -contains "Bob Smith") {
    Write-Host "FAIL: User 1 can see User 2" -ForegroundColor Red
} else {
    Write-Host "PASS: User 1 cannot see User 2" -ForegroundColor Green
}
Write-Host ""

# Test 11: User 2 lists users
Write-Host "Test 11: User 2 lists users" -ForegroundColor Cyan
$user2Users = Invoke-RestMethod -Uri "$BASE_URL/users" -Method Get -Headers $headers2
$user2UserNames = $user2Users.name
if ($user2UserNames -contains "Bob Smith") {
    Write-Host "PASS: User 2 sees their user" -ForegroundColor Green
} else {
    Write-Host "FAIL: User 2 cannot see their user" -ForegroundColor Red
}
if ($user2UserNames -contains "Alice Johnson") {
    Write-Host "FAIL: User 2 can see User 1" -ForegroundColor Red
} else {
    Write-Host "PASS: User 2 cannot see User 1" -ForegroundColor Green
}
Write-Host ""

# Test 12: Login with invalid credentials
Write-Host "Test 12: Login with invalid credentials" -ForegroundColor Cyan
$invalidLoginBody = @{
    email = "alice@companya.com"
    password = "wrongpassword"
} | ConvertTo-Json

try {
    $invalidLogin = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method Post -ContentType "application/json" -Body $invalidLoginBody
    Write-Host "FAIL: Invalid login succeeded" -ForegroundColor Red
} catch {
    Write-Host "PASS: Invalid login rejected" -ForegroundColor Green
}
Write-Host ""

# Test 13: Access protected endpoint without token
Write-Host "Test 13: Access protected endpoint without token" -ForegroundColor Cyan
try {
    $noToken = Invoke-RestMethod -Uri "$BASE_URL/tasks" -Method Get
    Write-Host "FAIL: Access without token allowed" -ForegroundColor Red
} catch {
    Write-Host "PASS: Access without token blocked" -ForegroundColor Green
}
Write-Host ""

# Test 14: User 1 updates their own task
Write-Host "Test 14: User 1 updates their own task" -ForegroundColor Cyan
$updateBody = @{
    title = "Company A Task (Updated)"
    description = "This task belongs to Company A"
    status = "IN_PROGRESS"
    assignedUserId = $USER1_ID
} | ConvertTo-Json

$updateResponse = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Put -ContentType "application/json" -Headers $headers1 -Body $updateBody
Write-Host "PASS: User 1 can update their own task" -ForegroundColor Green
Write-Host ""

# Test 15: User 2 tries to update User 1's task
Write-Host "Test 15: User 2 tries to update User 1's task" -ForegroundColor Cyan
$crossUpdateBody = @{
    title = "Hacked Task"
    description = "This should not work"
    status = "TODO"
    assignedUserId = $USER2_ID
} | ConvertTo-Json

try {
    $crossUpdate = Invoke-RestMethod -Uri "$BASE_URL/tasks/$TASK1_ID" -Method Put -ContentType "application/json" -Headers $headers2 -Body $crossUpdateBody
    Write-Host "FAIL: Cross-tenant update allowed" -ForegroundColor Red
} catch {
    Write-Host "PASS: Cross-tenant update blocked" -ForegroundColor Green
}
Write-Host ""

# Test Summary
Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "User 1 (Alice Johnson)" -ForegroundColor Gray
Write-Host "  Email: alice@companya.com" -ForegroundColor Gray
Write-Host "  Organization: Company A (ID: $USER1_ORG_ID)" -ForegroundColor Gray
Write-Host "  Task ID: $TASK1_ID" -ForegroundColor Gray
Write-Host ""
Write-Host "User 2 (Bob Smith)" -ForegroundColor Gray
Write-Host "  Email: bob@companyb.com" -ForegroundColor Gray
Write-Host "  Organization: Company B (ID: $USER2_ORG_ID)" -ForegroundColor Gray
Write-Host "  Task ID: $TASK2_ID" -ForegroundColor Gray
Write-Host ""
Write-Host "All tests completed" -ForegroundColor Green
