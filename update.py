import requests
import os


def download_latest_release_assets(owner, repo, download_dir="."):
    # GitHub API URL for latest release
    url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"

    response = requests.get(url)
    if response.status_code != 200:
        print(f"Error fetching release info: {response.status_code}")
        return

    release = response.json()
    assets = release.get("assets", [])
    if not assets:
        print("No assets found in the latest release.")
        return

    os.makedirs(download_dir, exist_ok=True)

    for asset in assets:
        asset_url = asset["browser_download_url"]
        asset_name = asset["name"]
        print(f"Downloading {asset_name} ...")

        r = requests.get(asset_url, stream=True)
        if r.status_code == 200:
            with open(os.path.join(download_dir, asset_name), "wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
            print(f"{asset_name} downloaded successfully.")
        else:
            print(f"Failed to download {asset_name}: HTTP {r.status_code}")


if __name__ == "__main__":
    # Replace 'owner' and 'repo' with the target repository details
    owner = "thebearodactyl"
    repo = "insolence-lib"
    download_latest_release_assets(owner, repo, download_dir="./lib")
