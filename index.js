const express = require('express');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const port = 4100;

let isProcessing = false;

// Route to execute the build script and stream logs in HTML format
app.get('/build/:commitId?', (req, res) => {
    if (isProcessing) {
        res.status(503).send('Server is busy processing another request. Please try again in 5 min.');
        return;
    }

    const commitId = req.params.commitId;
    isProcessing = true;

    // Prepare the arguments for spawn
    const args = commitId ? [commitId] : [];
    const script = spawn('./build.sh', args);

    res.setHeader('Content-Type', 'text/html');

    script.stdout.on('data', (data) => {
        res.write(`<pre>${data}</pre>`);
        console.log(data.toString());
    });

    script.stderr.on('data', (data) => {
        res.write(`<pre style="color: red;">Error: ${data}</pre>`);
    });

    script.on('close', (code) => {
        isProcessing = false;

        if (code === 0) {
            res.write('<pre>Build process completed successfully!</pre>');
            res.write('<a href="/download">Download the file</a>');
        } else {
            res.write(`<pre style="color: red;">Build process exited with code ${code}</pre>`);
        }
        res.end();
    });
});

app.get('/release', (req, res) => {
    if (isProcessing) {
        res.status(503).send('Server is busy processing another request. Please try again in 5 min.');
        return;
    }

    isProcessing = true;

    const script = spawn('./release.sh');

    res.setHeader('Content-Type', 'text/html');

    script.stdout.on('data', (data) => {
        res.write(`<pre>${data}</pre>`);
        console.log(data.toString());
    });

    script.stderr.on('data', (data) => {
        res.write(`<pre style="color: red;">Error: ${data}</pre>`);
    });

    script.on('close', (code) => {
        isProcessing = false;

        if (code === 0) {
            res.write('<pre>Build process completed successfully!</pre>');
            res.write('<a href="/download-prod">Download the file</a>');
        } else {
            res.write(`<pre style="color: red;">Build process exited with code ${code}</pre>`);
        }
        res.end();
    });
});

// Route to handle file download
app.get('/download', (req, res) => {
    const filePath = path.join(__dirname, '../cordova/tmp/app-debug.apk');
    res.download(filePath, 'app-debug.apk', (err) => {
        if (err) {
            console.error('File download failed:', err);
            res.status(500).send('File download failed.');
        } else {
            console.log('File downloaded successfully.');
        }
    });
});

// Route to handle file download
app.get('/download-prod', (req, res) => {
    const filePath = path.join(__dirname, '../cordova/tmp/app-release.aab');
    res.download(filePath, 'app-release.aab', (err) => {
        if (err) {
            console.error('File download failed:', err);
            res.status(500).send('File download failed.');
        } else {
            console.log('File downloaded successfully.');
        }
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
