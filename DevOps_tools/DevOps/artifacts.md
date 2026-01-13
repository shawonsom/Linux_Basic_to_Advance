### **1. What Are GitHub Artifacts?**
**Artifacts** are files generated during a **GitHub Actions workflow run** that you want to preserve and potentially use after the workflow finishes. They are the **output** of your CI/CD pipeline.

**Common examples include:**
*   Compiled binaries (`.exe`, `.jar`, `.dll`)
*   Built packages (`.deb`, `.rpm`, `.npm`, Docker images pushed to a registry)
*   Test reports and logs (JUnit XML, coverage reports)
*   Deployment bundles (ZIP files, static site builds)
*   Release assets (downloadable files attached to a GitHub Release)

---

### **2. Why Use Artifacts? They Solve Key Problems**

| Problem | Solution with Artifacts |
| :--- | :--- |
| **Debugging Failures** | Save logs, screenshots, or core dumps from a failed test to inspect later. |
| **Sharing Between Jobs** | Build code in one job (`build`), then upload the artifact and download it in a second job (`test` or `deploy`). |
| **Manual Testing/Deployment** | Upload a `.apk` file so QA can manually download and test it from the workflow run page. |
| **Staging for Releases** | Bundle release files and upload them as artifacts. Later, a release workflow can attach them to a GitHub Release. |

---

### **3. Key Properties & Limits**
*   **Storage Location:** Artifacts are stored on GitHub's servers, not in your git repository.
*   **Retention Period:**
    *   **90 days** for artifacts from pull requests.
    *   **400 days** for artifacts from the default branch and other branches (can be changed in repo settings).
    *   Artifacts expire and are automatically deleted.
*   **Size Limits:**
    *   **10 GB max per artifact** (with a warning above 2GB).
    *   **Total storage per repository** depends on your GitHub plan (Free: 500MB, Pro/Team: 2GB, Enterprise: varies). **Exceeding this will block workflows.**
    *   **Tip:** For very large outputs (like Docker images), push them to a container registry (Docker Hub, GitHub Container Registry) instead of using artifacts.

---

### **4. Core Actions for Working with Artifacts**
GitHub provides official actions in the `actions` namespace:

*   **`actions/upload-artifact`**: Uploads files/directories from a job's runner.
*   **`actions/download-artifact`**: Downloads previously uploaded artifacts to the runner.

---

### **5. How to Write Artifact Steps in a Workflow (YAML Examples)**

#### **Example 1: Basic Upload & Download Between Jobs**
```yaml
name: CI Pipeline

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build Application
        run: |
          make build
          # This creates a 'dist/' directory with binaries

      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: my-application-binaries
          path: dist/
          # Optional: specify a retention period in days
          retention-days: 7

  test:
    runs-on: ubuntu-latest
    needs: build # This job depends on the 'build' job
    steps:
      - name: Download Build Artifact
        uses: actions/download-artifact@v4
        with:
          name: my-application-binaries

      - name: List downloaded files
        run: ls -R

      - name: Run Tests
        run: ./run-tests.sh
```

#### **Example 2: Uploading Multiple Artifacts & Test Reports**
```yaml
- name: Upload Test Results
  if: always() # Upload logs even if tests fail
  uses: actions/upload-artifact@v4
  with:
    name: test-reports
    path: |
      test-results/junit.xml
      coverage-report/
      logs/

- name: Upload Package for Manual Download
  uses: actions/upload-artifact@v4
  with:
    name: release-package-v1.0.0
    path: release/package.zip
```

#### **Example 3: Downloading All Artifacts**
```yaml
- name: Download All Artifacts
  uses: actions/download-artifact@v4
  # Without 'name', it downloads all artifacts from the workflow run.
  # They are placed in directories named after each artifact.
```

---

### **6. Best Practices for Writing Artifact Steps**

1.  **Be Specific with Paths:** Upload only what you need. Don't upload `node_modules/` or huge cache directories.
    *   **Use:** `path: dist/app.jar`
    *   **Avoid:** `path: .` (the entire workspace)

2.  **Use Descriptive Names:** Instead of `artifact-1`, use names like `windows-build`, `integration-test-logs`, `docker-image-tarball`.

3.  **Control Retention:** Use `retention-days` for temporary artifacts (like test logs) to save storage. Keep release artifacts longer.

4.  **Clean Up Old Artifacts:** Go to **Settings > Actions > Artifact and log retention** in your repository to set global rules. Use the [GitHub API](https://docs.github.com/en/rest/actions/artifacts) or tools like [`actions/delete-artifact`](https://github.com/marketplace/actions/delete-artifact) in a cleanup workflow.

5.  **For Large Files:** Consider using `actions/cache` for dependencies that can be recreated (faster) and **only use artifacts for unique, necessary outputs**.

6.  **Use `if: always()` for Critical Debugging Files:** Ensure crucial logs (from a failing step) are uploaded even if the job fails.

---

### **7. Where to Find Uploaded Artifacts**
1.  Go to your repository on GitHub.com.
2.  Click on the **"Actions"** tab.
3.  Click on a specific workflow run.
4.  Look for the **"Artifacts"** section on the run summary page. You can browse and download them from there.

---

### **Summary**
*   **Artifacts = Workflow Outputs.** They are essential for **sharing data between jobs**, **persisting build results**, and **aiding in debugging**.
*   **Use `actions/upload-artifact` and `actions/download-artifact`** to manage them.
*   **Be mindful of storage limits** and clean up old artifacts regularly.
*   **Name them well** and upload only the necessary files.
