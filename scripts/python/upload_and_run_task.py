import os
import sys
import urllib.request
import json
import socket
import ssl

# Set UTF-8 encoding for stdout to handle Unicode characters
if sys.platform == "win32":
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

print("[DEBUG] Python script starting - checking network connectivity...")
print(f"[DEBUG] Python executable: {sys.executable}")
print(f"[DEBUG] Python version: {sys.version}")
print(f"[DEBUG] Python path: {sys.path}")

# Check if we're in a virtual environment
import os
if 'VIRTUAL_ENV' in os.environ:
    print(f"[DEBUG] Virtual environment: {os.environ['VIRTUAL_ENV']}")
else:
    print("[DEBUG] No virtual environment detected")

# Test basic network connectivity
try:
    print("[DEBUG] Testing DNS resolution for apis.roblox.com...")
    socket.gethostbyname('apis.roblox.com')
    print("[DEBUG] ✅ DNS resolution successful")
except Exception as e:
    print(f"[ERROR] ❌ DNS resolution failed: {e}")

try:
    print("[DEBUG] Testing HTTPS connection to apis.roblox.com...")
    # Test basic HTTPS connectivity
    req = urllib.request.Request('https://apis.roblox.com/', method='HEAD')
    req.add_header('User-Agent', 'Test/1.0')
    with urllib.request.urlopen(req, timeout=10) as response:
        print(f"[DEBUG] ✅ HTTPS connection successful, status: {response.status}")
except Exception as e:
    print(f"[ERROR] ❌ HTTPS connection failed: {e}")
    print(f"[DEBUG] Error type: {type(e).__name__}")

# Check SSL context
try:
    print("[DEBUG] Checking SSL context...")
    ssl_context = ssl.create_default_context()
    print(f"[DEBUG] SSL context created: {ssl_context}")
    print(f"[DEBUG] SSL verify mode: {ssl_context.verify_mode}")
    print(f"[DEBUG] SSL CA certs loaded: {ssl_context.ca_certs}")
except Exception as e:
    print(f"[ERROR] SSL context issue: {e}")

print("[DEBUG] Network diagnostics completed")
print("---")

from luau_execution_task import createTask, pollForTaskCompletion, getTaskLogs

print("[DEBUG] Python script starting - checking environment variables...")

# Check for required environment variables with proper error handling
try:
    ROBLOX_API_KEY = os.environ["ROBLOX_API_KEY"]
    print("[DEBUG] ROBLOX_API_KEY found")
except KeyError:
    print("[ERROR] ROBLOX_API_KEY environment variable not found!")
    sys.exit(1)

try:
    ROBLOX_UNIVERSE_ID = os.environ["ROBLOX_UNIVERSE_ID"]
    print(f"[DEBUG] ROBLOX_UNIVERSE_ID found: {ROBLOX_UNIVERSE_ID}")
except KeyError:
    print("[ERROR] ROBLOX_UNIVERSE_ID environment variable not found!")
    sys.exit(1)

try:
    ROBLOX_PLACE_ID = os.environ["ROBLOX_PLACE_ID"]
    print(f"[DEBUG] ROBLOX_PLACE_ID found: {ROBLOX_PLACE_ID}")
except KeyError:
    print("[ERROR] ROBLOX_PLACE_ID environment variable not found!")
    sys.exit(1)

print("[DEBUG] All required environment variables found!")

# Debug: Print environment variables (masking sensitive data)
print(f"Universe ID: {ROBLOX_UNIVERSE_ID}")
print(f"Place ID: {ROBLOX_PLACE_ID}")
print(f"API Key present: {'Yes' if ROBLOX_API_KEY else 'No'}")
print(f"API Key length: {len(ROBLOX_API_KEY) if ROBLOX_API_KEY else 0}")
print("---")


def read_file(file_path):
    with open(file_path, "rb") as file:
        return file.read()


def upload_place(binary_path, universe_id, place_id, do_publish=False):
    print("[DEBUG] Entering upload_place function")
    print("Uploading place to Roblox")
    print(f"Uploading to Universe ID: {universe_id}, Place ID: {place_id}")
    print(f"[DEBUG] Binary path: {binary_path}")
    print(f"[DEBUG] File exists: {os.path.exists(binary_path)}")
    
    version_type = "Published" if do_publish else "Saved"
    request_headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/xml",
        "Accept": "application/json",
    }

    url = f"https://apis.roblox.com/universes/v1/{universe_id}/places/{place_id}/versions?versionType={version_type}"
    print(f"API URL: {url}")

    print("[DEBUG] Reading binary file...")
    buffer = read_file(binary_path)
    print(f"[DEBUG] File size: {len(buffer)} bytes")
    
    print("[DEBUG] Creating HTTP request...")
    req = urllib.request.Request(
        url, data=buffer, headers=request_headers, method="POST"
    )

    print("[DEBUG] Sending request to Roblox API...")
    try:
        # Add timeout to prevent hanging
        with urllib.request.urlopen(req, timeout=60) as response:  # 60 second timeout
            print(f"[DEBUG] Response status: {response.status}")
            data = json.loads(response.read().decode("utf-8"))
            place_version = data.get("versionNumber")
            print(f"Successfully uploaded! Version: {place_version}")
            print("[DEBUG] Upload completed successfully")
            return place_version
    except urllib.error.HTTPError as e:
        print(f"[DEBUG] HTTP Error occurred: {e.code}")
        print(f"HTTP Error {e.code}: {e.reason}")
    except urllib.error.URLError as e:
        print(f"[DEBUG] URL Error occurred: {e}")
        print(f"URL Error: {e}")
        raise
    except Exception as e:
        print(f"[DEBUG] Unexpected error during upload: {e}")
        print(f"Upload error: {e}")
        raise
        if e.code == 404:
            print("ERROR: 404 Not Found - This usually means:")
            print("  - The Universe ID or Place ID is incorrect")
            print("  - The API key doesn't have access to this place")
            print("  - The place doesn't exist or has been deleted")
            print(f"  - Attempted Universe ID: {universe_id}")
            print(f"  - Attempted Place ID: {place_id}")
        elif e.code == 401:
            print("ERROR: 401 Unauthorized - API key is invalid or expired")
        elif e.code == 403:
            print("ERROR: 403 Forbidden - API key doesn't have permission to upload to this place")
        
        # Try to read error response body
        try:
            error_body = e.read().decode('utf-8')
            print(f"Error response: {error_body}")
        except:
            pass
        
        raise


def run_luau_task(universe_id, place_id, place_version, script_file, test_pattern=None):
    print("[DEBUG] Entering run_luau_task function")
    print("Executing Luau task")
    print(f"[DEBUG] Script file: {script_file}")
    print(f"[DEBUG] Script file exists: {os.path.exists(script_file)}")
    
    script_contents = read_file(script_file).decode("utf8")    # If test pattern is provided, inject it into the script
    print(f"[DEBUG] Script contents length: {len(script_contents)} characters")
    
    if test_pattern:
        print(f"Test pattern: {test_pattern}")
        # Insert test pattern variable at the beginning of the script (after the first line)
        lines = script_contents.split('\n')
        if len(lines) > 0:
            # Insert after the first line (usually local ReplicatedStorage...)
            pattern_injection = f'local TEST_PATTERN = "{test_pattern}"'
            lines.insert(1, pattern_injection)
            script_contents = '\n'.join(lines)
            print(f"Injected TEST_PATTERN into script")
            # Debug: print first few lines of modified script
            modified_lines = script_contents.split('\n')[:5]
            print("Modified script preview:")
            for i, line in enumerate(modified_lines):
                print(f"  {i+1}: {line}")
    else:
        print("No test pattern provided - running all tests")
    
    print("[DEBUG] Creating Luau execution task...")
    task = createTask(
        ROBLOX_API_KEY, script_contents, universe_id, place_id, place_version
    )
    print(f"[DEBUG] Task created: {task}")
    
    print("[DEBUG] About to start polling for task completion...")
    print(f"[DEBUG] Task path for polling: {task['path']}")
    task = pollForTaskCompletion(ROBLOX_API_KEY, task["path"])
    print(f"[DEBUG] Task completed with state: {task['state']}")
    
    print("[DEBUG] Getting task logs...")
    logs = getTaskLogs(ROBLOX_API_KEY, task["path"])
    print(f"[DEBUG] Logs retrieved, length: {len(logs)} characters")

    # Print logs with proper Unicode handling
    print("[DEBUG] Printing task logs...")
    try:
        print(logs)
        sys.stdout.flush()
        print("[DEBUG] Logs printed successfully")
    except UnicodeEncodeError:
        print("[DEBUG] Unicode error, trying with error replacement...")
        # If Unicode fails, print with error replacement
        print(logs.encode('utf-8', errors='replace').decode('utf-8'))
        sys.stdout.flush()
    except Exception as e:
        print(f"[DEBUG] Error printing logs: {e}")
        print(f"Error printing logs: {e}")
        print("Raw logs (may have encoding issues):")
        print(repr(logs))
        sys.stdout.flush()

    print(f"[DEBUG] Task final state: {task['state']}")
    if task["state"] == "COMPLETE":
        print("[DEBUG] Task completed successfully - exiting with code 0")
        print("Lua task completed successfully")
        exit(0)
    else:
        print(f"[DEBUG] Task failed with state: {task['state']} - exiting with code 1")
        print("Luau task failed", file=sys.stderr)
        exit(1)


if __name__ == "__main__":
    print("[DEBUG] Starting upload_and_run_task.py")
    print(f"[DEBUG] Arguments: {sys.argv}")
    
    universe_id = ROBLOX_UNIVERSE_ID
    place_id = ROBLOX_PLACE_ID
    binary_file = sys.argv[1]
    script_file = sys.argv[2]
    
    print(f"[DEBUG] Binary file: {binary_file}")
    print(f"[DEBUG] Script file: {script_file}")
    
    # Get test pattern from command line argument if provided
    test_pattern = sys.argv[3] if len(sys.argv) > 3 else None
    print(f"[DEBUG] Test pattern: {test_pattern}")

    print("[DEBUG] About to upload place...")
    place_version = upload_place(binary_file, universe_id, place_id)
    print(f"[DEBUG] Place uploaded, version: {place_version}")
    
    print("[DEBUG] About to run Luau task...")
    run_luau_task(universe_id, place_id, place_version, script_file, test_pattern)
    print("[DEBUG] Luau task completed successfully")