import os
import sys
import urllib.request
import json

# Set UTF-8 encoding for stdout to handle Unicode characters
if sys.platform == "win32":
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

from luau_execution_task import createTask, pollForTaskCompletion, getTaskLogs

ROBLOX_API_KEY = os.environ["ROBLOX_API_KEY"]
ROBLOX_UNIVERSE_ID = os.environ["ROBLOX_UNIVERSE_ID"]
ROBLOX_PLACE_ID = os.environ["ROBLOX_PLACE_ID"]

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
    print("Uploading place to Roblox")
    print(f"Uploading to Universe ID: {universe_id}, Place ID: {place_id}")
    version_type = "Published" if do_publish else "Saved"
    request_headers = {
        "x-api-key": ROBLOX_API_KEY,
        "Content-Type": "application/xml",
        "Accept": "application/json",
    }

    url = f"https://apis.roblox.com/universes/v1/{universe_id}/places/{place_id}/versions?versionType={version_type}"
    print(f"API URL: {url}")

    buffer = read_file(binary_path)
    req = urllib.request.Request(
        url, data=buffer, headers=request_headers, method="POST"
    )

    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode("utf-8"))
            place_version = data.get("versionNumber")
            print(f"Successfully uploaded! Version: {place_version}")
            return place_version
    except urllib.error.HTTPError as e:
        print(f"HTTP Error {e.code}: {e.reason}")
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
    print("Executing Luau task")
    script_contents = read_file(script_file).decode("utf8")    # If test pattern is provided, inject it into the script
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
    
    task = createTask(
        ROBLOX_API_KEY, script_contents, universe_id, place_id, place_version
    )
    task = pollForTaskCompletion(ROBLOX_API_KEY, task["path"])
    logs = getTaskLogs(ROBLOX_API_KEY, task["path"])

    # Print logs with proper Unicode handling
    try:
        print(logs)
        sys.stdout.flush()
    except UnicodeEncodeError:
        # If Unicode fails, print with error replacement
        print(logs.encode('utf-8', errors='replace').decode('utf-8'))
        sys.stdout.flush()
    except Exception as e:
        print(f"Error printing logs: {e}")
        print("Raw logs (may have encoding issues):")
        print(repr(logs))
        sys.stdout.flush()

    if task["state"] == "COMPLETE":
        print("Lua task completed successfully")
        exit(0)
    else:
        print("Luau task failed", file=sys.stderr)
        exit(1)


if __name__ == "__main__":
    universe_id = ROBLOX_UNIVERSE_ID
    place_id = ROBLOX_PLACE_ID
    binary_file = sys.argv[1]
    script_file = sys.argv[2]
    
    # Get test pattern from command line argument if provided
    test_pattern = sys.argv[3] if len(sys.argv) > 3 else None

    place_version = upload_place(binary_file, universe_id, place_id)
    run_luau_task(universe_id, place_id, place_version, script_file, test_pattern)